//
//  AdhkarTourFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture

/// Parent orchestrator that walks the user through a set of adhkar one dhikr at a
/// time. It hosts every dhikr as a child `DhikrFeature`; each child owns its own
/// counter and works independently. Completing a dhikr does not advance the tour —
/// the user taps or swipes to move on. Advancing past the last dhikr sets
/// `activeID` to `nil`, showing the completion screen; from there `.delegate(.finished)`
/// asks the parent to dismiss the tour.
@Reducer
struct AdhkarTourFeature {
    @ObservableState
    struct State: Equatable {
        /// Localized string key for the collection name (e.g. `"morning_adhkar"`),
        /// stored as a raw key so it can be both rendered and interpolated.
        let title: String
        var dhikrStates: IdentifiedArrayOf<DhikrFeature.State>
        var activeID: DhikrFeature.State.ID?

        var isFinished: Bool { activeID == nil }
        var total: Int { dhikrStates.count }
        var completedCount: Int { dhikrStates.filter(\.isComplete).count }

        /// 1-based position of the active dhikr in tour order, for the header
        /// counter and progress bar. `nil` once the tour is finished.
        var activeIndex: Int? {
            guard let activeID, let index = dhikrStates.index(id: activeID) else { return nil }
            return index + 1
        }

        init(title: String, adhkar: [Dhikr]) {
            self.title = title
            dhikrStates = IdentifiedArray(uniqueElements: adhkar.map { DhikrFeature.State(dhikr: $0) })
            activeID = dhikrStates.first?.id
        }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case nextTapped
            case previousTapped
            case finishTapped
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction {
            case finished
        }

        @CasePathable
        enum DependentAction {
            case dhikr(IdentifiedActionOf<DhikrFeature>)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.nextTapped):
                state.advance()
                return .none

            case .view(.previousTapped):
                state.moveActive(by: -1)
                return .none

            case .view(.finishTapped):
                return .send(.delegate(.finished))

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
    /// Moves to the next dhikr in tour order, or sets `activeID` to `nil` when past
    /// the last one — which shows the completion screen.
    mutating func advance() {
        guard let activeID, let index = dhikrStates.index(id: activeID) else { return }
        let next = index + 1
        self.activeID = dhikrStates.indices.contains(next) ? dhikrStates[next].id : nil
    }

    /// Clamped backward navigation used by swipe. No-ops at the first dhikr, so it
    /// never sets `activeID` to `nil`.
    mutating func moveActive(by offset: Int) {
        guard let activeID, let index = dhikrStates.index(id: activeID) else { return }
        let target = index + offset
        guard dhikrStates.indices.contains(target) else { return }
        self.activeID = dhikrStates[target].id
    }
}
