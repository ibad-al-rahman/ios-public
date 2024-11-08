//
//  LanguageView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import ComposableArchitecture
import SwiftUI

struct LanguageView: View {
    @Bindable var store: StoreOf<LanguageFeature>

    var body: some View {
        Form {
            Picker("Language", selection: $store.language) {
                ForEach(Settings.Language.allCases) {
                    Text(verbatim: $0.rawValue).tag($0)
                }
            }
            .pickerStyle(.inline)
        }
    }
}

#Preview {
    LanguageView(store: Store(
        initialState: LanguageFeature.State(),
        reducer: LanguageFeature.init
    ))
}

#Preview {
    LanguageView(store: Store(
        initialState: LanguageFeature.State(),
        reducer: LanguageFeature.init
    ))
    .arabicEnvironment()
}
