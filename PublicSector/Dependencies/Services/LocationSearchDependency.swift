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
        completer.resultTypes = .address
        completer.pointOfInterestFilter = .excludingAll
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
                guard let placemark = response?.mapItems.first?.placemark,
                      placemark.locality != nil || placemark.country != nil,
                      placemark.thoroughfare == nil, // reject street addresses
                      placemark.subThoroughfare == nil // reject house numbers
                else { return nil }
                return placemark.coordinate
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
        continuation?.yield(completer.results.filter(Self.isCityOrCountry))
    }

    /// Keeps only city / country completions, dropping street-level addresses.
    /// A street address begins with a house number (e.g. "10 Downing Street"),
    /// so any completion whose title starts with a digit is rejected. The
    /// `resolve` step re-validates against structured placemark data.
    private static func isCityOrCountry(_ completion: MKLocalSearchCompletion) -> Bool {
        let title = completion.title.trimmingCharacters(in: .whitespaces)
        guard let first = title.first else { return false }
        return !first.isNumber
    }
}
