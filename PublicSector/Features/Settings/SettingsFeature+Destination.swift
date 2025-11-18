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
            case notifications(NotificationsFeature.State)

            var id: AnyHashable {
                switch self {
                case .help: "help"
                case .appearance: "appearance"
                case .notifications: "notifications"
                }
            }
        }

        enum Action {
            case help(HelpFeature.Action)
            case appearance(AppearanceFeature.Action)
            case notifications(NotificationsFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.help, action: \.help) {
                HelpFeature()
            }

            Scope(state: \.appearance, action: \.appearance) {
                AppearanceFeature()
            }

            Scope(state: \.notifications, action: \.notifications) {
                NotificationsFeature()
            }
        }
    }
}
