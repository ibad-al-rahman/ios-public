//
//  AppEntryView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/12/2024.
//

import ComposableArchitecture
import SwiftUI

struct AppEntryView: View {
    let store: StoreOf<AppEntryFeature>

    var body: some View {
        switch store.state {
        case .app:
            if let scopedStore = store.scope(
                state: \.app, action: \.app
            ) {
                AppView(store: scopedStore)
            }

        case .startup:
            if let scopedStore = store.scope(
                state: \.startup,
                action: \.startup
            ) {
                StartupView(store: scopedStore)
            }
        }
    }
}
