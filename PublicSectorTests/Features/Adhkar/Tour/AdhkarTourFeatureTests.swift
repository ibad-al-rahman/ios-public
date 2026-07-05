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

    /// Builds tour state around bespoke fixtures. The navigation logic under test is
    /// collection-agnostic, so we seed a real collection then swap in the fixtures.
    private static func state(_ adhkar: [Dhikr]) -> AdhkarTourFeature.State {
        var state = AdhkarTourFeature.State(collection: .morning)
        state.dhikrStates = IdentifiedArray(uniqueElements: adhkar.map { DhikrFeature.State(dhikr: $0) })
        state.activeID = state.dhikrStates.first?.id
        return state
    }

    @Test
    func initSeedsChildrenAndActivatesFirst() {
        let state = Self.state(Self.adhkar)

        #expect(state.dhikrStates.count == 2)
        #expect(state.activeID == Self.first.id)
        #expect(state.activeIndex == 1)
        #expect(state.total == 2)
        #expect(state.completedCount == 0)
        #expect(!state.isFinished)
    }

    @Test
    func completingActiveDhikrDoesNotAdvance() async {
        let store = TestStore(initialState: Self.state(Self.adhkar)) {
            AdhkarTourFeature()
        }

        // Tapping up to the target completes the dhikr but the tour stays put —
        // the completing tap does not delegate.
        await store.send(.dependent(.dhikr(.element(id: Self.first.id, action: .view(.tapped))))) {
            $0.dhikrStates[id: Self.first.id]?.count = 1
        }
        await store.send(.dependent(.dhikr(.element(id: Self.first.id, action: .view(.tapped))))) {
            $0.dhikrStates[id: Self.first.id]?.count = 2
        }

        #expect(store.state.activeID == Self.first.id)
        #expect(!store.state.isFinished)
    }

    @Test
    func tappingCompletedDhikrAdvances() async {
        var initialState = Self.state(Self.adhkar)
        // First dhikr already complete, active.
        initialState.dhikrStates[id: Self.first.id]?.count = Self.first.target

        let store = TestStore(initialState: initialState) {
            AdhkarTourFeature()
        }

        // Tapping the already-complete dhikr delegates `.completed`, and the tour
        // advances to the next one.
        await store.send(.dependent(.dhikr(.element(id: Self.first.id, action: .view(.tapped)))))
        await store.receive(\.dependent.dhikr[id: Self.first.id].delegate.completed) {
            $0.activeID = Self.second.id
        }
    }

    @Test
    func nextTappedAtLastDhikrFinishesTour() async {
        var initialState = Self.state(Self.adhkar)
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
        var initialState = Self.state(Self.adhkar)
        initialState.activeID = nil

        let store = TestStore(initialState: initialState) {
            AdhkarTourFeature()
        }

        await store.send(.view(.finishTapped))
        await store.receive(\.delegate.finished)
    }

    @Test
    func swipeNavigatesForwardAndBackward() async {
        let store = TestStore(initialState: Self.state(Self.trio)) {
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
        let store = TestStore(initialState: Self.state(Self.trio)) {
            AdhkarTourFeature()
        }

        // Already on the first dhikr — swiping back does nothing.
        await store.send(.view(.previousTapped))
    }

    @Test
    func nextAtLastDhikrFinishesTour() async {
        var initialState = Self.state(Self.trio)
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
