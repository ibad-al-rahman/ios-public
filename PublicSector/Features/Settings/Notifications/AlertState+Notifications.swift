//
//  AlertState+Notifications.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/03/2026.
//

import ComposableArchitecture

extension AlertState where Action == NotificationsFeature.Destination.Action.Alert {
    static var unauthorizedNotificationPermission: Self {
        AlertState {
            TextState("notifications_disabled")
        } actions: {
            ButtonState(role: .cancel, action: .cancel) {
                TextState("cancel")
            }
            ButtonState(action: .openSettings) {
                TextState("open_settings")
            }
        } message: {
            TextState("enable_notifications_prayer_alert")
        }
    }
}
