//
//  Permissions.swift
//  PublicSector
//
//  Created by Hamza Jadid on 01/08/2025.
//

import Dependencies
import DependenciesMacros
import UserNotifications

@DependencyClient
struct Permissions: Sendable {
    var requestPushNotificationPermission: @Sendable () async throws -> Bool = { false }
    var getPushNotificationPermissionStatus: @Sendable () async -> UNAuthorizationStatus = { .notDetermined }
}

extension Permissions: DependencyKey {
    static let liveValue: Permissions = {
        Permissions(
            requestPushNotificationPermission: {
                try await UNUserNotificationCenter
                    .current()
                    .requestAuthorization(options: [.badge, .sound, .alert])
            },
            getPushNotificationPermissionStatus: {
                let settings = await UNUserNotificationCenter
                    .current()
                    .notificationSettings()
                return settings.authorizationStatus
            }
        )
    }()
}

extension Permissions {
    static let testValue: Permissions = {
        Permissions()
    }()
}

extension DependencyValues {
    var permissions: Permissions {
        get { self[Permissions.self] }
        set { self[Permissions.self] = newValue }
    }
}
