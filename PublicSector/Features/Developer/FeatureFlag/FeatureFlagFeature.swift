//
//  FeatureFlagFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 20/12/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FeatureFlagFeature {
    @ObservableState
    struct State: Equatable { }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction { }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
