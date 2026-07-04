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
    func incrementBelowTargetDoesNotComplete() async {
        let store = TestStore(initialState: DhikrFeature.State(dhikr: Self.dhikr)) {
            DhikrFeature()
        }

        await store.send(.view(.incrementTapped)) {
            $0.count = 1
        }
        await store.send(.view(.incrementTapped)) {
            $0.count = 2
        }
    }

    @Test
    func incrementReachingTargetCompletes() async {
        let store = TestStore(initialState: DhikrFeature.State(dhikr: Self.dhikr, count: 2)) {
            DhikrFeature()
        }

        await store.send(.view(.incrementTapped)) {
            $0.count = 3
        }
        await store.receive(\.delegate.completed)
    }

    @Test
    func incrementPastTargetIsNoOp() async {
        let store = TestStore(initialState: DhikrFeature.State(dhikr: Self.dhikr, count: 3)) {
            DhikrFeature()
        }

        // Already complete — tapping again must not change count or re-fire delegate.
        await store.send(DhikrFeature.Action.view(.incrementTapped))
    }
}
