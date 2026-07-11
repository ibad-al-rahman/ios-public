//
//  ContentView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    @Dependency(\.deepLinkParser) private var deepLinkParser
    @Dependency(\.deepLinkBus) private var deepLinkBus

    @State private var store = Store(
        initialState: AppEntryFeature.State.startup(StartupFeature.State()),
        reducer: AppEntryFeature.init
    )

    var body: some View {
        ZStack {
            appEntry
            debugButton
        }
        // Custom-scheme deep links (e.g. `app://adhkar/morning`).
        .onOpenURL { url in
            guard let route = deepLinkParser.parse(url: url) else { return }
            store.send(.deepLink(route))
        }
        // Deep links routed from outside the store (notification taps in AppDelegate).
        .task {
            for await route in deepLinkBus.routes() {
                store.send(.deepLink(route))
            }
        }
    }

    private var appEntry: some View {
        AppEntryView(store: store)
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
