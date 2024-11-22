//
//  EditSinglePrayerTimeFeatue.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture

@Reducer
struct EditSinglePrayerTimeFeature {
    @ObservableState
    struct State: Equatable {
        var offset = 0
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case onTapInc
            case onTapDec
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
            case .view(.onTapInc):
                state.offset += 1
                return .none

            case .view(.onTapDec):
                state.offset -= 1
                return .none

            default: return .none
            }
        }
    }
}
