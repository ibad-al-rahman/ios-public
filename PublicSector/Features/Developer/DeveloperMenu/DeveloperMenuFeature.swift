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
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

        enum ViewAction {
            case onTapDone
            case onTapSimulateCrash
            case onTapFeatureFlag
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case destination(PresentationAction<Destination.Action>)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onTapDone):
                return .run { _ in await dismiss() }

            case .view(.onTapSimulateCrash):
                return .run { _ in fatalError("This is a simulated crash!") }

            case .view(.onTapFeatureFlag):
                state.destination = .featureFlag(FeatureFlagFeature.State())
                return .none

            case .reducer, .delegate, .dependent:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }
}
