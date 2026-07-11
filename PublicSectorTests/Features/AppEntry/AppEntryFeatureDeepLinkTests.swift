//
//  AppEntryFeatureDeepLinkTests.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import ComposableArchitecture
import Testing
@testable import PublicSector

@MainActor
@Suite
struct AppEntryFeatureDeepLinkTests {
    @Test
    func deepLinkFromStartupEntersAppAndNavigates() async {
        let store = TestStore(initialState: AppEntryFeature.State.startup(StartupFeature.State())) {
            AppEntryFeature()
        } withDependencies: {
            $0.remoteConfig.isFlagEnabled = { _ in false }
        }
        store.exhaustivity = .off

        await store.send(.deepLink(.adhkar(.collection(.morning)))) {
            $0 = .app(AppFeature.State())
        }
        await store.receive(\.app.reducer.deepLink) {
            $0 = .app({
                var appState = AppFeature.State()
                appState.selectedTab = .adhkar
                appState.adhkar.destination = .tour(AdhkarTourFeature.State(collection: .morning))
                return appState
            }())
        }
    }

    @Test
    func deepLinkIgnoredDuringForcedUpdate() async {
        let store = TestStore(initialState: AppEntryFeature.State.startup(StartupFeature.State())) {
            AppEntryFeature()
        } withDependencies: {
            $0.remoteConfig.isFlagEnabled = { $0 == .forceUpdate }
        }

        await store.send(.deepLink(.adhkar(.collection(.morning))))
    }
}
