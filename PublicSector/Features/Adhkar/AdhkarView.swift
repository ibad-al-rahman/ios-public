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
                    NavigationRowView("Morning adhkar", systemName: "sun.horizon")
                        .onTapGesture { store.send(.view(.onTapMorning)) }
                    NavigationRowView("Evening adhkar", systemName: "moon.stars")
                        .onTapGesture { store.send(.view(.onTapEvening)) }
                } header: {
                    Spacer(minLength: Spacing.small)
                }
            }
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.morning,
                    action: \.dependent.destination.morning
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.evening,
                    action: \.dependent.destination.evening
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationTitle("Adhkar")
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
