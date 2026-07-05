//
//  AdhkarTourFeatureTests.swift
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
struct AdhkarTourFeatureTests {
    private static let first = Dhikr(
        id: UUID(uuidString: "00000000-0000-0000-0000-0000000000B1")!,
        arabicText: "الأول",
        target: 2
    )
    private static let second = Dhikr(
        id: UUID(uuidString: "00000000-0000-0000-0000-0000000000B2")!,
        arabicText: "الثاني",
        target: 1
    )

    private static let third = Dhikr(
        id: UUID(uuidString: "00000000-0000-0000-0000-0000000000B3")!,
        arabicText: "الثالث",
        target: 1
    )

    private static let adhkar = [first, second]
    private static let trio = [first, second, third]

    @Test
    func initSeedsChildrenAndActivatesFirst() {
        let state = AdhkarTourFeature.State(title: "morning_adhkar", adhkar: Self.adhkar)

        #expect(state.dhikrStates.count == 2)
        #expect(state.activeID == Self.first.id)
        #expect(state.activeIndex == 1)
        #expect(state.total == 2)
        #expect(state.completedCount == 0)
        #expect(!state.isFinished)
    }

    @Test
    func completingActiveDhikrDoesNotAdvance() async {
        let store = TestStore(initialState: AdhkarTourFeature.State(title: "morning_adhkar", adhkar: Self.adhkar)) {
            AdhkarTourFeature()
        }

        await store.send(.dependent(.dhikr(.element(id: Self.first.id, action: .view(.incrementTapped))))) {
            $0.dhikrStates[id: Self.first.id]?.count = 1
        }
        await store.send(.dependent(.dhikr(.element(id: Self.first.id, action: .view(.incrementTapped))))) {
            $0.dhikrStates[id: Self.first.id]?.count = 2
        }
        // Completing the dhikr delegates `.completed` but the tour stays put —
        // the user taps or swipes to advance.
        await store.receive(\.dependent.dhikr[id: Self.first.id].delegate.completed)

        #expect(store.state.activeID == Self.first.id)
        #expect(!store.state.isFinished)
    }

    @Test
    func nextTappedAtLastDhikrFinishesTour() async {
        var initialState = AdhkarTourFeature.State(title: "morning_adhkar", adhkar: Self.adhkar)
        // Both dhikr complete, sitting on the last one.
        initialState.dhikrStates[id: Self.first.id]?.count = Self.first.target
        initialState.dhikrStates[id: Self.second.id]?.count = Self.second.target
        initialState.activeID = Self.second.id

        let store = TestStore(initialState: initialState) {
            AdhkarTourFeature()
        }

        await store.send(.view(.nextTapped)) {
            $0.activeID = nil
        }

        #expect(store.state.isFinished)
        #expect(store.state.completedCount == 2)
    }

    @Test
    func finishTappedDelegatesFinished() async {
        var initialState = AdhkarTourFeature.State(title: "morning_adhkar", adhkar: Self.adhkar)
        initialState.activeID = nil

        let store = TestStore(initialState: initialState) {
            AdhkarTourFeature()
        }

        await store.send(.view(.finishTapped))
        await store.receive(\.delegate.finished)
    }

    @Test
    func swipeNavigatesForwardAndBackward() async {
        let store = TestStore(initialState: AdhkarTourFeature.State(title: "morning_adhkar", adhkar: Self.trio)) {
            AdhkarTourFeature()
        }

        await store.send(.view(.nextTapped)) {
            $0.activeID = Self.second.id
        }
        await store.send(.view(.nextTapped)) {
            $0.activeID = Self.third.id
        }
        await store.send(.view(.previousTapped)) {
            $0.activeID = Self.second.id
        }
    }

    @Test
    func previousAtFirstDhikrIsNoOp() async {
        let store = TestStore(initialState: AdhkarTourFeature.State(title: "morning_adhkar", adhkar: Self.trio)) {
            AdhkarTourFeature()
        }

        // Already on the first dhikr — swiping back does nothing.
        await store.send(.view(.previousTapped))
    }

    @Test
    func nextAtLastDhikrFinishesTour() async {
        var initialState = AdhkarTourFeature.State(title: "morning_adhkar", adhkar: Self.trio)
        initialState.activeID = Self.third.id

        let store = TestStore(initialState: initialState) {
            AdhkarTourFeature()
        }

        // On the last dhikr — advancing forward finishes the tour.
        await store.send(.view(.nextTapped)) {
            $0.activeID = nil
        }

        #expect(store.state.isFinished)
    }
}
