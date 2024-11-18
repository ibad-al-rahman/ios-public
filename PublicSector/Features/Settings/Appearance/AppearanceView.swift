//
//  AppearanceView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import ComposableArchitecture
import SwiftUI

struct AppearanceView: View {
    @Bindable var store: StoreOf<AppearanceFeature>

    var body: some View {
        Form {
            Picker("Theme", selection: $store.appearance) {
                ForEach(Settings.Appearance.allCases) {
                    Text($0.localizedStringKey).tag($0)
                }
            }
            .pickerStyle(.inline)
        }
    }
}

#Preview {
    AppearanceView(store: Store(
        initialState: AppearanceFeature.State(),
        reducer: AppearanceFeature.init
    ))
}

#Preview {
    AppearanceView(store: Store(
        initialState: AppearanceFeature.State(),
        reducer: AppearanceFeature.init
    ))
    .arabicEnvironment()
}
