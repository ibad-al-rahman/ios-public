//
//  AppFeatureDeepLinkTests.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import ComposableArchitecture
import Testing
@testable import PublicSector

@MainActor
@Suite
struct AppFeatureDeepLinkTests {
    @Test
    func deepLinkSelectsAdhkarTabAndOpensTour() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        store.exhaustivity = .off

        await store.send(.reducer(.deepLink(.adhkar(.collection(.evening))))) {
            $0.selectedTab = .adhkar
            $0.adhkar.destination = .tour(AdhkarTourFeature.State(collection: .evening))
        }
    }

    @Test
    func deepLinkSelectsPrayerTimesTab() async {
        let store = TestStore(initialState: AppFeature.State(selectedTab: .settings)) {
            AppFeature()
        }
        store.exhaustivity = .off

        await store.send(.reducer(.deepLink(.prayerTimes))) {
            $0.selectedTab = .prayerTimes
        }
    }
}
