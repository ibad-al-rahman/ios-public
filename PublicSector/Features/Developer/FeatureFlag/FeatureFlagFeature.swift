//
//  FeatureFlagFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 20/12/2024.
//

import ComposableArchitecture
import IbadRemoteConfig
import Foundation

@Reducer
struct FeatureFlagFeature {
    @Dependency(\.remoteConfig) private var remoteConfig

    @ObservableState
    struct State: Equatable {
        var flags: [FeatureFlag] = []
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case onAppear
            case onToggle(key: FeatureFlagKey, newValue: Bool)
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
            case .view(.onAppear):
                state.flags = remoteConfig.allFeatureFlags()
                return .none

            case let .view(.onToggle(key, newValue)):
                remoteConfig.setFlag(key: key, newValue: newValue)
                state.flags = remoteConfig.allFeatureFlags()
                return .none

            default:
                return .none
            }
        }
    }
}
