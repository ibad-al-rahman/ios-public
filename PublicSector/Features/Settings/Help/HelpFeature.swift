//
//  HelpFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture

@Reducer
struct HelpFeature {
    @Dependency(\.webLinks) private var webLinks

    @ObservableState
    struct State: Equatable { }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case onTapContactUs
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onTapContactUs):
                return .run { _ in await webLinks.openContactUs() }

            default:
                return .none
            }
        }
    }
}
