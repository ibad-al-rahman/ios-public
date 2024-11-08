//
//  DeveloperMenuView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct DeveloperMenuView: View {
    let store: StoreOf<DeveloperMenuFeature>

    var body: some View {
        NavigationStack {
            List {
                actionsSection
            }
            .navigationTitle("Developer Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolBarItem }
        }
    }

    @ToolbarContentBuilder
    private var toolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                store.send(.onTapDone)
            } label: {
                Text("Done")
            }
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
