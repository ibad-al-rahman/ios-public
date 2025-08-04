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
    var pushNotificationPermission: @Sendable () async throws -> Bool = { false }
}

extension Permissions: DependencyKey {
    static let liveValue: Permissions = {
        Permissions(
            pushNotificationPermission: {
                try await UNUserNotificationCenter
                    .current()
                    .requestAuthorization(options: [.badge, .sound, .alert])
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
