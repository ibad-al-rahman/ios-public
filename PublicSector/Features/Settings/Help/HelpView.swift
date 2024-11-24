//
//  HelpView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct HelpView: View {
    @Bindable var store: StoreOf<HelpFeature>

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationRowView("Contact us", systemName: "text.bubble")
                        .onTapGesture { store.send(.onTapContactUs) }
                }

                Section("App Info") {
                    Text("Version").badge(Text(verbatim: "0.1.0"))
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
