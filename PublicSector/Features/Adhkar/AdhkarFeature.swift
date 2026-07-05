//
//  AdhkarFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture

@Reducer
struct AdhkarFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case collectionTapped(AdhkarCollection)
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
            case let .view(.collectionTapped(collection)):
                state.destination = .tour(AdhkarTourFeature.State(collection: collection))
                return .none

            case .dependent(.destination(.presented(.tour(.delegate(.finished))))):
                state.destination = nil
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }
}
