//
//  SettingsView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    @Bindable var store: StoreOf<SettingsFeature>

    var body: some View {
        NavigationStack {
            List {
                displaySection

                Section {
                    Label("Notifications", systemImage: "app.badge")
                        .foregroundStyle(.primary, .primary)
                }

                Section("App Info") {
                    Text("Version").badge(Text(verbatim: "0.1.0"))
                }
            }
            .navigationTitle("Settings")
        }
    }

    private var displaySection: some View {
        Section("Display") {
            navigationRow("Appearance", systemName: "circle.lefthalf.filled")
                .onTapGesture { store.send(.onTapAppearance) }
                .navigationDestination(
                    item: $store.scope(
                        state: \.destination?.appearance,
                        action: \.dependent.destination.appearance
                    ),
                    destination: { AppearanceView(store: $0) }
                )

            navigationRow("Language", systemName: "a.square")
                .onTapGesture { store.send(.onTapLanguage) }
                .navigationDestination(
                    item: $store.scope(
                        state: \.destination?.language,
                        action: \.dependent.destination.language
                    ),
                    destination: { LanguageView(store: $0) }
                )
        }
    }

    private func navigationRow(
        _ label: LocalizedStringKey, systemName: String
    ) -> some View {
        HStack {
            Label(label, systemImage: systemName)
                .foregroundStyle(.primary, .primary)
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    SettingsView(store: Store(
        initialState: SettingsFeature.State(),
        reducer: SettingsFeature.init
    ))
}

#Preview {
    SettingsView(store: Store(
        initialState: SettingsFeature.State(),
        reducer: SettingsFeature.init
    ))
    .arabicEnvironment()
}
