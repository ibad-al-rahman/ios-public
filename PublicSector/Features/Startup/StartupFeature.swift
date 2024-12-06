//
//  StartupFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/12/2024.
//

import ComposableArchitecture

@Reducer
struct StartupFeature {
    @ObservableState
    struct State: Equatable { }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

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
