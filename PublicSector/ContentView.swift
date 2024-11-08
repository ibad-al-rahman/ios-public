//
//  ContentView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            app
//            debugButton
        }
    }

    private var app: some View {
        AppView(store: Store(
            initialState: AppFeature.State(),
            reducer: AppFeature.init
        ))
    }

    private var debugButton: some View {
        DeveloperButtonView(store: Store(
            initialState: DeveloperButtonFeature.State(),
            reducer: DeveloperButtonFeature.init
        ))
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView().arabicEnvironment()
}
