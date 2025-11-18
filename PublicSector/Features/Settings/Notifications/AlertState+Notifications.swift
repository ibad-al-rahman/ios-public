//
//  AlertState+Notifications.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/11/2025.
//

import ComposableArchitecture

extension AlertState where Action == NotificationsFeature.Destination.Action.Alert {
    static var unauthorizedNotificationPermission: Self {
        AlertState {
            TextState("Notifications Disabled")
        } actions: {
            ButtonState(role: .cancel, action: .cancel) {
                TextState("Cancel")
            }
            ButtonState(action: .openSettings) {
                TextState("Open Settings")
            }
        } message: {
            TextState("Please enable notifications in Settings to receive prayer time alerts.")
        }
    }
}
