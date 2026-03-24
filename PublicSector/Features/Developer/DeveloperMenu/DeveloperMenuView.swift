//
//  DeveloperMenuView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct DeveloperMenuView: View {
    @Bindable var store: StoreOf<DeveloperMenuFeature>

    var body: some View {
        NavigationStack {
            List {
                configurationSection
                actionsSection
            }
            .navigationTitle("developer_menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolBarItem }
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.featureFlag,
                    action: \.dependent.destination.featureFlag
                ),
                destination: { FeatureFlagView(store: $0) }
            )
        }
    }

    @ToolbarContentBuilder
    private var toolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                store.send(.onTapDone)
            } label: {
                Text("done")
            }
        }
    }

    private var configurationSection: some View {
        Section {
            DeveloperNavigationRowView(
                verbatim: "Feature Flags",
                systemName: "flag.and.flag.filled.crossed"
            )
            .onTapGesture { store.send(.onTapFeatureFlag) }
        } header: {
            Text(verbatim: "Config")
        }
    }

    private var actionsSection: some View {
        Section {
            Button(
                role: .destructive,
                action: { store.send(.onTapSimulateCrash) }
            ) {
                Text(verbatim: "Simulate Crash")
            }
        } header: {
            Text(verbatim: "Actions")
        }
    }
}

#Preview {
    DeveloperMenuView(store: Store(
        initialState: DeveloperMenuFeature.State(),
        reducer: DeveloperMenuFeature.init
    ))
}
