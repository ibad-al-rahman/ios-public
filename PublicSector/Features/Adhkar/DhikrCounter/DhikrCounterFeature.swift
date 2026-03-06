//
//  DhikrCounterFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 06/03/2026.
//

import ComposableArchitecture

@Reducer
struct DhikrCounterFeature {
    @ObservableState
    struct State: Equatable {
        let dhikr: Dhikr
        var remaining: Int

        init(dhikr: Dhikr) {
            self.dhikr = dhikr
            self.remaining = dhikr.count
        }

        var isDone: Bool { remaining == 0 }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case onTap
            case onReset
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onTap):
                guard !state.isDone else { return .none }
                state.remaining -= 1
                return .none

            case .view(.onReset):
                state.remaining = state.dhikr.count
                return .none

            default:
                return .none
            }
        }
    }
}
