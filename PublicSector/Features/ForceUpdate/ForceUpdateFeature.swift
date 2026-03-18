//
//  ForceUpdateFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/03/2026.
//

import ComposableArchitecture

@Reducer
struct ForceUpdateFeature {
    @Dependency(\.externalDeepLinks.appStorePage) private var openAppStore

    @ObservableState
    struct State: Equatable { }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

        enum ViewAction {
            case onTapUpdate
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
            case .view(.onTapUpdate):
                return .run { _ in
                    await openAppStore()
                }

            default:
                return .none
            }
        }
    }
}
