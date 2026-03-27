//
//  LocationSearchDependency.swift
//  PublicSector
//
//  Created by Hamza Jadid on 27/03/2026.
//

@preconcurrency import MapKit
import Dependencies

struct LocationSearchDependency {
    var completions: @Sendable (String) -> AsyncStream<[MKLocalSearchCompletion]>
    var resolve: @Sendable (MKLocalSearchCompletion) async -> CLLocationCoordinate2D?
}

extension LocationSearchDependency: DependencyKey {
    static let liveValue: Self = {
        let completer = MKLocalSearchCompleter()
        let delegate = CompleterDelegate()

        return Self(
            completions: { query in
                AsyncStream { continuation in
                    Task { @MainActor in
                        delegate.continuation = continuation
                        completer.delegate = delegate
                        completer.queryFragment = query
                    }

                    continuation.onTermination = { _ in
                        Task { @MainActor in
                            delegate.continuation = nil
                        }
                    }
                }
            },

            resolve: { completion in
                let request = MKLocalSearch.Request(completion: completion)
                let search = MKLocalSearch(request: request)
                let response = try? await search.start()
                return response?.mapItems.first?.placemark.coordinate
            }
        )
    }()
}

extension DependencyValues {
    var locationSearch: LocationSearchDependency {
        get { self[LocationSearchDependency.self] }
        set { self[LocationSearchDependency.self] = newValue }
    }
}

final class CompleterDelegate: NSObject, MKLocalSearchCompleterDelegate, @unchecked Sendable {
    var continuation: AsyncStream<[MKLocalSearchCompletion]>.Continuation?

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        continuation?.yield(completer.results)
    }
}
