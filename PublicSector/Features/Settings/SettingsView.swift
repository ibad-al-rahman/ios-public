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
            HStack {
                Label("Appearance", systemImage: "circle.lefthalf.filled")
                    .foregroundStyle(.primary, .primary)
                    .onTapGesture { store.send(.onTapAppearance) }
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.appearance,
                    action: \.dependent.destination.appearance
                ),
                destination: { AppearanceView(store: $0) }
            )

            HStack {
                Label("Language", systemImage: "a.square")
                    .foregroundStyle(.primary, .primary)
                    .onTapGesture { store.send(.onTapLanguage) }
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.language,
                    action: \.dependent.destination.language
                ),
                destination: { LanguageView(store: $0) }
            )
        }
    }
}

#Preview {
    SettingsView(store: .init(
        initialState: SettingsFeature.State(),
        reducer: SettingsFeature.init
    ))
}

#Preview {
    SettingsView(store: .init(
        initialState: SettingsFeature.State(),
        reducer: SettingsFeature.init
    ))
    .arabicEnvironment()
}
