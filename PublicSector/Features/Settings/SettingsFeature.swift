//
//  SettingsFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SettingsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onTapAppearance
            case onTapLanguage
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
                state.destination = .language(LanguageFeature.State())
                return .none

            default: return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }
}
