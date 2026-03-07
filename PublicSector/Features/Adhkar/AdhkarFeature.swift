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
            case onTapMorning
            case onTapEvening
            case onTapAfterPrayer
            case onTapBeforeSleep
            case onTapWakingUp
            case onTapEating
            case onTapGeneralSupplications
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
            case .view(.onTapMorning):
                state.destination = .morning(DhikrListFeature.State(category: .morning))
                return .none

            case .view(.onTapEvening):
                state.destination = .evening(DhikrListFeature.State(category: .evening))
                return .none

            case .view(.onTapAfterPrayer):
                state.destination = .afterPrayer(DhikrListFeature.State(category: .afterPrayer))
                return .none

            case .view(.onTapBeforeSleep):
                state.destination = .beforeSleep(DhikrListFeature.State(category: .beforeSleep))
                return .none

            case .view(.onTapWakingUp):
                state.destination = .wakingUp(DhikrListFeature.State(category: .wakingUp))
                return .none

            case .view(.onTapEating):
                state.destination = .eating(DhikrListFeature.State(category: .eating))
                return .none

            case .view(.onTapGeneralSupplications):
                state.destination = .generalSupplications(DhikrListFeature.State(category: .generalSupplications))
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
