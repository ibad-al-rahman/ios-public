//
//  DhikrFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture

/// A single dhikr in the tour. Owns its own repetition counter and signals its
/// parent, via `delegate(.completed)`, once the target count is reached.
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
            case incrementTapped
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction {
            case completed
        }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.incrementTapped):
                guard !state.isComplete else { return .none }
                state.count += 1
                return state.isComplete ? .send(.delegate(.completed)) : .none

            default:
                return .none
            }
        }
    }
}
