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

    private static let adhkar = [first, second]

    @Test
    func initSeedsChildrenAndActivatesFirst() {
        let state = AdhkarTourFeature.State(adhkar: Self.adhkar)

        #expect(state.dhikrStates.count == 2)
        #expect(state.activeID == Self.first.id)
        #expect(state.total == 2)
        #expect(state.completedCount == 0)
        #expect(!state.isFinished)
    }

    @Test
    func completingActiveDhikrAdvancesToNext() async {
        let store = TestStore(initialState: AdhkarTourFeature.State(adhkar: Self.adhkar)) {
            AdhkarTourFeature()
        }

        await store.send(.dependent(.dhikr(.element(id: Self.first.id, action: .view(.incrementTapped))))) {
            $0.dhikrStates[id: Self.first.id]?.count = 1
        }
        await store.send(.dependent(.dhikr(.element(id: Self.first.id, action: .view(.incrementTapped))))) {
            $0.dhikrStates[id: Self.first.id]?.count = 2
        }
        await store.receive(\.dependent.dhikr[id: Self.first.id].delegate.completed) {
            $0.activeID = Self.second.id
        }
    }

    @Test
    func completingLastDhikrFinishesTour() async {
        var initialState = AdhkarTourFeature.State(adhkar: Self.adhkar)
        // Start on the last dhikr with the first already complete.
        initialState.dhikrStates[id: Self.first.id]?.count = Self.first.target
        initialState.activeID = Self.second.id

        let store = TestStore(initialState: initialState) {
            AdhkarTourFeature()
        }

        await store.send(.dependent(.dhikr(.element(id: Self.second.id, action: .view(.incrementTapped))))) {
            $0.dhikrStates[id: Self.second.id]?.count = 1
        }
        await store.receive(\.dependent.dhikr[id: Self.second.id].delegate.completed) {
            $0.activeID = nil
        }

        #expect(store.state.isFinished)
        #expect(store.state.completedCount == 2)
    }
}
