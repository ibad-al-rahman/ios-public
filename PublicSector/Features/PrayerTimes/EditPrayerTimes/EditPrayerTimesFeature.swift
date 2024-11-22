//
//  EditPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture

@Reducer
struct EditPrayerTimesFeature {
    @ObservableState
    struct State: Equatable { }

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
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
