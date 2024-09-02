//
//  SettingsView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    let store: StoreOf<SettingsFeature>

    var body: some View {
        NavigationStack {
            List {
                Section("Display") {
                    NavigationLink(
                        destination: { Text(verbatim: "Hello World") }
                    ) {
                        Label("Appearance", systemImage: "circle.lefthalf.filled")
                            .foregroundStyle(.primary, .primary)
                    }

                    NavigationLink(
                        destination: { Text(verbatim: "Hello World") }
                    ) {
                        Label("Language", systemImage: "a.square")
                            .foregroundStyle(.primary, .primary)
                    }
                }

                Section {
                    NavigationLink(
                        destination: { Text(verbatim: "Hello World") }
                    ) {
                        Label("Notifications", systemImage: "app.badge")
                            .foregroundStyle(.primary, .primary)
                    }
                }

                Section("App Info") {
                    Text("Version").badge(Text(verbatim: "0.1.0"))
                }
            }
            .navigationTitle("Settings")
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
