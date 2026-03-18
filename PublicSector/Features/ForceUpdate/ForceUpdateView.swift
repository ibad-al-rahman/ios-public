//
//  ForceUpdateView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/03/2026.
//

import ComposableArchitecture
import SwiftUI

struct ForceUpdateView: View {
    let store: StoreOf<ForceUpdateFeature>

    var body: some View {
        VStack(spacing: .extraLarge) {
            Image("MultiColorLogo")
                .resizable()
                .frame(maxWidth: 250, maxHeight: 250)
                .scaledToFit()

            Text("A new version is available. Update the app to continue.")
                .multilineTextAlignment(.center)

            Button("Update Now") {
                store.send(.onTapUpdate)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ForceUpdateView(store: Store(
        initialState: ForceUpdateFeature.State(),
        reducer: ForceUpdateFeature.init
    ))
}

#Preview {
    ForceUpdateView(store: Store(
        initialState: ForceUpdateFeature.State(),
        reducer: ForceUpdateFeature.init
    ))
    .arabicEnvironment()
}
