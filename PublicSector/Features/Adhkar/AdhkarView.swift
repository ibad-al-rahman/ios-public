//
//  AdhkarView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct AdhkarView: View {
    @Bindable var store: StoreOf<AdhkarFeature>

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(AdhkarCollection.allCases) { collection in
                        Button {
                            store.send(.view(.collectionTapped(collection)))
                        } label: {
                            NavigationRowView(
                                LocalizedStringKey(collection.titleKey),
                                systemName: collection.systemImage
                            )
                        }
                        .foregroundStyle(.primary)
                    }
                } header: {
                    Spacer(minLength: Spacing.small)
                }
            }
            .navigationTitle("adhkar")
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.tour,
                    action: \.dependent.destination.tour
                ),
                destination: { AdhkarTourView(store: $0) }
            )
        }
    }
}

#Preview {
    AdhkarView(store: Store(
        initialState: AdhkarFeature.State(),
        reducer: AdhkarFeature.init
    ))
}

#Preview {
    AdhkarView(store: Store(
        initialState: AdhkarFeature.State(),
        reducer: AdhkarFeature.init
    ))
    .arabicEnvironment()
}
