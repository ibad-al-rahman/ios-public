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
        Group {
            if store.query.isEmpty {
                ContentUnavailableView(
                    "search_for_location",
                    systemImage: "magnifyingglass",
                    description: Text("search_for_location_description")
                )
            } else if store.completions.isEmpty {
                ContentUnavailableView.search(text: store.query)
            } else {
                List {
                    Section {
                        ForEach(store.completions) { completion in
                            Button {
                                store.send(.onCompletionTapped(completion))
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(completion.title)
                                    if !completion.subtitle.isEmpty {
                                        Text(completion.subtitle)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $store.query, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("location")
        .onAppear { store.send(.onAppear) }
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

