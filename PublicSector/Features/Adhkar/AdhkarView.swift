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
                    Button {
                        store.send(.view(.morningTapped))
                    } label: {
                        NavigationRowView("morning_adhkar", systemName: "sun.horizon")
                    }
                    .foregroundStyle(.primary)

                    Button {
                        store.send(.view(.eveningTapped))
                    } label: {
                        NavigationRowView("evening_adhkar", systemName: "moon.stars")
                    }
                    .foregroundStyle(.primary)
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
