//
//  DhikrFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture

/// A single dhikr in the tour. Owns its own repetition counter. A tap increments
/// while counting; once the target is reached the next tap signals the parent, via
/// `delegate(.completed)`, to advance the tour.
@Reducer
struct DhikrFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        let dhikr: Dhikr
        var count: Int = 0

        var id: Dhikr.ID { dhikr.id }
        var isComplete: Bool { count >= dhikr.target }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case tapped
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction {
            /// Sent when the user taps an already-complete dhikr, asking the tour to
            /// advance to the next one.
            case completed
        }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.tapped):
                guard !state.isComplete else {
                    // Already done — the tap asks the tour to move on.
                    return .send(.delegate(.completed))
                }
                state.count += 1
                return .none

            default:
                return .none
            }
        }
    }
}
