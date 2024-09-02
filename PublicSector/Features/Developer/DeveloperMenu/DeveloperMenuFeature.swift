//
//  DeveloperMenuFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture

@Reducer
struct DeveloperMenuFeature {
    @Dependency(\.dismiss) private var dismiss

    @ObservableState
    struct State: Equatable { }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

        enum ViewAction {
            case onTapDone
            case onTapSimulateCrash
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
            case .view(.onTapDone):
                return .run { _ in await dismiss() }

            case .view(.onTapSimulateCrash):
                return .run { _ in fatalError("This is a simulated crash!") }

            case .reducer, .delegate, .dependent:
                return .none
            }
        }
    }
}
