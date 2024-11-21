//
//  SettingsFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture

@Reducer
struct SettingsFeature {
    @Dependency(\.webLinks) private var webLinks
    @Dependency(\.externalDeepLinks) private var externalDeepLinks

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onTapAppearance
            case onTapLanguage
            case onTapDonate
            case onTapHelp
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
            case .view(.onTapAppearance):
                state.destination = .appearance(AppearanceFeature.State())
                return .none

            case .view(.onTapLanguage):
                return .run { _ in await externalDeepLinks.appSettings() }

            case .view(.onTapDonate):
                return .run { _ in await webLinks.openDonationLink() }

            case .view(.onTapHelp):
                state.destination = .help(HelpFeature.State())
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
