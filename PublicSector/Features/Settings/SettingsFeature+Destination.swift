//
//  SettingsFeature+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import ComposableArchitecture

extension SettingsFeature {
    @Reducer
    struct Destination {
        enum State: Identifiable, Equatable {
            case appearance(AppearanceFeature.State)

            var id: AnyHashable {
                switch self {
                case .appearance: "appearance"
                }
            }
        }

        enum Action {
            case appearance(AppearanceFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.appearance, action: \.appearance) {
                AppearanceFeature()
            }
        }
    }
}
