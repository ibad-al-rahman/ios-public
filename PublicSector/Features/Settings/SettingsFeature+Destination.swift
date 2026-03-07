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
            case help(HelpFeature.State)
            case appearance(AppearanceFeature.State)
            case adhkarNotifications(AdhkarNotificationsFeature.State)

            var id: AnyHashable {
                switch self {
                case .help: "help"
                case .appearance: "appearance"
                case .adhkarNotifications: "adhkarNotifications"
                }
            }
        }

        enum Action {
            case help(HelpFeature.Action)
            case appearance(AppearanceFeature.Action)
            case adhkarNotifications(AdhkarNotificationsFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.help, action: \.help) {
                HelpFeature()
            }

            Scope(state: \.appearance, action: \.appearance) {
                AppearanceFeature()
            }

            Scope(state: \.adhkarNotifications, action: \.adhkarNotifications) {
                AdhkarNotificationsFeature()
            }
        }
    }
}
