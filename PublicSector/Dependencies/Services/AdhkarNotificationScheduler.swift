//
//  AdhkarNotificationScheduler.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import Dependencies
import DependenciesMacros
import Foundation
import IbadRemoteConfig
import Sharing
import UserNotifications

struct AdhkarNotificationService {
    func scheduleNotifications() async {
        @Shared(.notificationsEnabled) var notificationsEnabled = false
        @Shared(.adhkarNotifications) var adhkar = Settings.AdhkarNotifications()
        @Dependency(\.remoteConfig) var remoteConfig

        guard remoteConfig.isFlagEnabled(key: .adhkarNotifications) else { return }

        let center = UNUserNotificationCenter.current()
        let pendingRequests = await center.pendingNotificationRequests()
        let adhkarIdentifiers = pendingRequests
            .map(\.identifier)
            .filter { $0.hasPrefix("adhkar-") }
        center.removePendingNotificationRequests(withIdentifiers: adhkarIdentifiers)

        guard notificationsEnabled else { return }

        let reminders: [(identifier: String, title: String, body: String, time: DateComponents, enabled: Bool)] = [
            (
                AdhkarCollection.morning.notificationIdentifier,
                String(localized: "morning_adhkar"),
                String(localized: "notification_body_morning_adhkar"),
                adhkar.morningTime,
                adhkar.morningEnabled
            ),
            (
                AdhkarCollection.evening.notificationIdentifier,
                String(localized: "evening_adhkar"),
                String(localized: "notification_body_evening_adhkar"),
                adhkar.eveningTime,
                adhkar.eveningEnabled
            ),
        ]

        for reminder in reminders where reminder.enabled {
            let content = UNMutableNotificationContent()
            content.title = reminder.title
            content.body = reminder.body
            content.sound = .default

            let components = DateComponents(hour: reminder.time.hour, minute: reminder.time.minute)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(
                identifier: reminder.identifier,
                content: content,
                trigger: trigger
            )

            try? await center.add(request)
        }
    }
}

@DependencyClient
struct AdhkarNotificationScheduler: Sendable {
    var scheduleNotifications: @Sendable () async -> Void
}

extension AdhkarNotificationScheduler: DependencyKey {
    static let liveValue = {
        let service = AdhkarNotificationService()
        return AdhkarNotificationScheduler(
            scheduleNotifications: { await service.scheduleNotifications() }
        )
    }()
}

extension AdhkarNotificationScheduler {
    static let testValue = AdhkarNotificationScheduler()
}

extension DependencyValues {
    var adhkarNotificationScheduler: AdhkarNotificationScheduler {
        get { self[AdhkarNotificationScheduler.self] }
        set { self[AdhkarNotificationScheduler.self] = newValue }
    }
}
