//
//  AdhkarTourFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture

/// Parent orchestrator that walks the user through a set of adhkar one dhikr at a
/// time. It hosts every dhikr as a child `DhikrFeature`; each child owns its own
/// counter and works independently. When a child reaches its target it delegates
/// `.completed` back up, and the tour advances the active dhikr. Once the last
/// dhikr completes, `activeID` is `nil` and the tour is finished.
@Reducer
struct AdhkarTourFeature {
    @ObservableState
    struct State: Equatable {
        var dhikrStates: IdentifiedArrayOf<DhikrFeature.State>
        var activeID: DhikrFeature.State.ID?

        var isFinished: Bool { activeID == nil }
        var total: Int { dhikrStates.count }
        var completedCount: Int { dhikrStates.filter(\.isComplete).count }

        init(adhkar: [Dhikr]) {
            dhikrStates = IdentifiedArray(uniqueElements: adhkar.map { DhikrFeature.State(dhikr: $0) })
            activeID = dhikrStates.first?.id
        }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction { }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case dhikr(IdentifiedActionOf<DhikrFeature>)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .dependent(.dhikr(.element(id: id, action: .delegate(.completed)))):
                state.activeID = state.nextID(after: id)
                return .none

            default:
                return .none
            }
        }
        .forEach(\.dhikrStates, action: \.dependent.dhikr) {
            DhikrFeature()
        }
    }
}

private extension AdhkarTourFeature.State {
    /// The id of the dhikr following the given one in tour order, or `nil` when it
    /// is the last (which finishes the tour).
    func nextID(after id: DhikrFeature.State.ID) -> DhikrFeature.State.ID? {
        guard let index = dhikrStates.index(id: id) else { return nil }
        let nextIndex = dhikrStates.index(after: index)
        return nextIndex < dhikrStates.endIndex ? dhikrStates[nextIndex].id : nil
    }
}
