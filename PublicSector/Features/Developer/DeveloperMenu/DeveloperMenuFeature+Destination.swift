//
//  DeveloperMenuFeature+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 20/12/2024.
//

import ComposableArchitecture

extension DeveloperMenuFeature {
    @Reducer
    struct Destination {
        enum State: Identifiable, Equatable {
            case featureFlag(FeatureFlagFeature.State)

            var id: AnyHashable {
                switch self {
                case .featureFlag: "feature-flag"
                }
            }
        }

        enum Action {
            case featureFlag(FeatureFlagFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.featureFlag, action: \.featureFlag) {
                FeatureFlagFeature()
            }
        }
    }
}
