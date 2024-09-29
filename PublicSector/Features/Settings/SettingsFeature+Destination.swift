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
            case language(LanguageFeature.State)

            var id: AnyHashable {
                switch self {
                case .appearance: "appearance"
                case .language: "language"
                }
            }
        }

        enum Action {
            case appearance(AppearanceFeature.Action)
            case language(LanguageFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.appearance, action: \.appearance) {
                AppearanceFeature()
            }
            Scope(state: \.language, action: \.language) {
                LanguageFeature()
            }
        }
    }
}
