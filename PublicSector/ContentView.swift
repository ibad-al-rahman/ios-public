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
            appEntry
//            debugButton
        }
    }

    private var appEntry: some View {
        AppEntryView(store: Store(
            initialState: .app(AppFeature.State()),
            reducer: AppEntryFeature.init
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
