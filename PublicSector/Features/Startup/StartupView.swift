//
//  StartupView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/12/2024.
//

import ComposableArchitecture
import SwiftUI

struct StartupView: View {
    let store: StoreOf<StartupFeature>

    var body: some View {
        ZStack {
            Image("Logo")
                .resizable()
                .frame(maxWidth: 250, maxHeight: 250)
                .scaledToFit()
        }
        .ignoresSafeArea()
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    StartupView(store: Store(
        initialState: StartupFeature.State(),
        reducer: StartupFeature.init
    ))
}

#Preview {
    StartupView(store: Store(
        initialState: StartupFeature.State(),
        reducer: StartupFeature.init
    ))
    .arabicEnvironment()
}
