//
//  NotificationsFeature+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/03/2026.
//

import ComposableArchitecture

extension NotificationsFeature {
    @Reducer
    struct Destination {
        enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }

        enum Action {
            case alert(Alert)

            enum Alert {
                case openSettings
                case cancel
            }
        }
    }
}
