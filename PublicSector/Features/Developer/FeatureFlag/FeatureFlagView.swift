//
//  FeatureFlagView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 20/12/2024.
//

import ComposableArchitecture
import IbadRemoteConfig
import SwiftUI

struct FeatureFlagView: View {
    let store: StoreOf<FeatureFlagFeature>

    var body: some View {
        List {
            ForEach(store.flags, id: \.key.rawValue) { flag in
                Toggle(isOn: Binding(
                    get: { flag.value },
                    set: { newValue in
                        store.send(.onToggle(key: flag.key, newValue: newValue))
                    }
                )) {
                    VStack(alignment: .leading) {
                        Text(verbatim: flag.key.display)
                        Text(verbatim: flag.key.description)
                            .font(.caption2)
                    }
                }
            }
        }
        .toolbar { toolbarItems }
        .onAppear { store.send(.onAppear) }
    }

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(role: .destructive, action: { store.send(.onTapReset) }) {
                Text(verbatim: "Reset")
                    .foregroundStyle(.red, .red)
            }
        }
    }
}
