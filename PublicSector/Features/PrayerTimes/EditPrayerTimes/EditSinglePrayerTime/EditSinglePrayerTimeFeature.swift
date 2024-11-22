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
        let prayer: Prayer
        @Shared(.prayerTimesOffset) var offset = .default
        var prayerOffset: Int {
            offset.val(prayer)
        }
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
                state.offset.inc(state.prayer)
                return .none

            case .view(.onTapDec):
                state.offset.dec(state.prayer)
                return .none

            default: return .none
            }
        }
    }
}
