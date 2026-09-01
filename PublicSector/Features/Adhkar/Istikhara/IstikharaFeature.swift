//
//  IstikharaFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 01/09/2026.
//

import ComposableArchitecture
import SwiftUI

/// The Istikhara screen. On appear it prompts the user, via a native alert, for the
/// decision they are seeking guidance on, then renders the duaa with that decision
/// substituted inline and emphasized. Until a decision is confirmed the duaa shows
/// the neutral placeholder wording.
@Reducer
struct IstikharaFeature {
    @ObservableState
    struct State: Equatable {
        /// Bound to the prompt's text field while the user is typing.
        var decision: String = ""
        /// Drives the native prompt alert. Raised on appear and again when the user
        /// chooses to edit their decision.
        var isPromptPresented: Bool = false
        /// The confirmed decision, filled into the duaa. `nil` until the user confirms.
        var confirmedDecision: String?

        /// The duaa with `confirmedDecision` substituted at both placeholder positions
        /// and emphasized, or the neutral wording before confirmation.
        var duaa: AttributedString { Istikhara.attributed(with: confirmedDecision) }
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onAppear
            case onTapEdit
            case onTapConfirm
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction {
            case finished
        }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                guard state.confirmedDecision == nil else { return .none }
                state.isPromptPresented = true
                return .none

            case .view(.onTapEdit):
                state.decision = state.confirmedDecision ?? ""
                state.isPromptPresented = true
                return .none

            case .view(.onTapConfirm):
                state.confirmedDecision = state.decision
                state.isPromptPresented = false
                return .none

            default:
                return .none
            }
        }
    }
}
