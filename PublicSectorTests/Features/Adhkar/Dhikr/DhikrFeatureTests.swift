//
//  DhikrFeatureTests.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import PublicSector

@MainActor
@Suite
struct DhikrFeatureTests {
    private static let dhikr = Dhikr(
        id: UUID(uuidString: "00000000-0000-0000-0000-0000000000AA")!,
        arabicText: "سُبْحَانَ اللَّهِ",
        target: 3
    )

    @Test
    func tapBelowTargetIncrements() async {
        let store = TestStore(initialState: DhikrFeature.State(dhikr: Self.dhikr)) {
            DhikrFeature()
        }

        await store.send(.view(.tapped)) {
            $0.count = 1
        }
        await store.send(.view(.tapped)) {
            $0.count = 2
        }
    }

    @Test
    func tapReachingTargetCompletesWithoutAdvancing() async {
        let store = TestStore(initialState: DhikrFeature.State(dhikr: Self.dhikr, count: 2)) {
            DhikrFeature()
        }

        // The completing tap fills the count and stops — it does not delegate,
        // so the tour stays on the done state.
        await store.send(.view(.tapped)) {
            $0.count = 3
        }
    }

    @Test
    func tapWhenCompleteRequestsAdvance() async {
        let store = TestStore(initialState: DhikrFeature.State(dhikr: Self.dhikr, count: 3)) {
            DhikrFeature()
        }

        // Already complete — the tap asks the tour to advance, count unchanged.
        await store.send(.view(.tapped))
        await store.receive(\.delegate.completed)
    }
}
