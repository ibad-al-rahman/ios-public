//
//  DeveloperButtonFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct DeveloperButtonFeature {
    @ObservableState
    struct State: Equatable {
        var offset = CGSize(width: 150, height: -300)
        @Presents var destination: Destination.State?
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onTapDeveloperButton
            case onGestureEnd(translation: CGSize)
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
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onTapDeveloperButton):
                state.destination = .developerMenu(DeveloperMenuFeature.State())
                return .none

            case .view(.onGestureEnd(translation: let translation)):
                let width = state.offset.width + translation.width
                let height = state.offset.height + translation.height
                let offset = CGSize(width: width, height: height)
                state.offset = offset
                return .none

            case .reducer, .delegate, .dependent, .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }
}
