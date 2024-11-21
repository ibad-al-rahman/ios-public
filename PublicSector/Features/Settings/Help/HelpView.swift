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
                    navigationRow("Contact us", systemName: "text.bubble")
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
