//
//  HelpView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import IbadEnvironment
import SwiftUI

struct HelpView: View {
    @Bindable var store: StoreOf<HelpFeature>
    @Dependency(\.appDetails) private var appDetails

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationRowView("contact_us", systemName: "text.bubble")
                        .onTapGesture { store.send(.onTapContactUs) }
                }

                Section("app_info") {
                    Text("version").badge(Text(verbatim: appDetails.versionString))
                    Text("build_number")
                        .badge(Text(verbatim: appDetails.buildString))
                }
            }
            .navigationTitle("help")
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
