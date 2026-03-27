//
//  LocationSearchView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 27/03/2026.
//

import ComposableArchitecture
import SwiftUI

struct LocationSearchView: View {
    @Bindable var store: StoreOf<LocationSearchFeature>

    var body: some View {
        List {
            if let coordinate = store.resolvedCoordinate {
                Section("location_coordinates") {
                    LabeledContent(
                        String(localized: "latitude"),
                        value: coordinate.latitude.formatted(.number.precision(.fractionLength(6)))
                    )
                    LabeledContent(
                        String(localized: "longitude"),
                        value: coordinate.longitude.formatted(.number.precision(.fractionLength(6)))
                    )
                }
            }

            Section {
                if store.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    ForEach(store.completions) { completion in
                        Button {
                            store.send(.view(.completionTapped(completion)))
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(completion.title)
                                    .foregroundStyle(.primary)
                                if !completion.subtitle.isEmpty {
                                    Text(completion.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $store.query)
        .navigationTitle("location_search")
        .onAppear { store.send(.view(.onAppear)) }
    }
}

#Preview {
    NavigationStack {
        LocationSearchView(store: Store(
            initialState: LocationSearchFeature.State(),
            reducer: LocationSearchFeature.init
        ))
    }
}

#Preview {
    NavigationStack {
        LocationSearchView(store: Store(
            initialState: LocationSearchFeature.State(),
            reducer: LocationSearchFeature.init
        ))
        .arabicEnvironment()
    }
}

