//
//  HelpView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import Dependencies
import SwiftUI

struct HelpView: View {
    @Bindable var store: StoreOf<HelpFeature>
    @Dependency(\.appInfo) private var appInfo

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationRowView("Contact us", systemName: "text.bubble")
                        .onTapGesture { store.send(.onTapContactUs) }
                }

                Section("App Info") {
                    Text("Version").badge(Text(verbatim: appInfo.version()))
                    Text("Build number")
                        .badge(Text(verbatim: appInfo.buildNumber()))
                }
            }
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HelpView(store: Store(
        initialState: HelpFeature.State(),
        reducer: HelpFeature.init
    ))
}

#Preview {
    HelpView(store: Store(
        initialState: HelpFeature.State(),
        reducer: HelpFeature.init
    ))
    .arabicEnvironment()
}
