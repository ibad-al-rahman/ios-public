//
//  PrayerTimesNotificationScheduler.swift
//  PublicSector
//
//  Created by Hamza Jadid on 19/03/2026.
//

@preconcurrency import BackgroundTasks
import Dependencies
import DependenciesMacros
import IbadRemoteConfig
import Foundation
import MiqatKit
import Sharing
import UserNotifications

struct PrayerTimesNotificationService {
    private static let taskIdentifier = "com.ibadalrahman.PublicSector.azan_notification_scheduler"

    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.taskIdentifier,
            using: nil
        ) { task in
            guard let refreshTask = task as? BGAppRefreshTask else { return }

            let workTask = Task {
                await self.scheduleNotifications()
                self.submitBackgroundTaskRequest()
                refreshTask.setTaskCompleted(success: true)
            }

            refreshTask.expirationHandler = {
                workTask.cancel()
                refreshTask.setTaskCompleted(success: false)
            }
        }

        submitBackgroundTaskRequest()
    }

    private func submitBackgroundTaskRequest() {
        let request = BGAppRefreshTaskRequest(identifier: Self.taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }

    func scheduleNotifications() async {
        @Shared(.notificationsEnabled) var notificationsEnabled = false
        @Shared(.prayerTimesNotifications) var prayerTimes = Settings.PrayerTimesNotifications()
        @Dependency(\.miqatService) var miqatService
        @Dependency(\.remoteConfig) var remoteConfig

        guard remoteConfig.isFlagEnabled(key: .prayerTimesNotifications) else { return }

        let center = UNUserNotificationCenter.current()
        let pendingRequests = await center.pendingNotificationRequests()
        let prayerIdentifiers = pendingRequests
            .map(\.identifier)
            .filter { $0.hasPrefix("prayertimes-") }
        center.removePendingNotificationRequests(withIdentifiers: prayerIdentifiers)

        guard notificationsEnabled else { return }

        let tzOffset = TimeZone.current.secondsFromGMT()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        for dayOffset in 0 ..< 7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            let timestamp = date.timeIntervalSince1970 + TimeInterval(tzOffset)
            let miqatData = miqatService.getMiqatData(timestampSecs: timestamp, provider: .darElFatwa(.beirut))

            let prayers: [(name: String, title: String, body: String, date: Date, enabled: Bool)] = [
                (
                    "fajr",
                    String(localized: "fajr"),
                    String(localized: "notification_body_fajr"),
                    miqatData.fajr,
                    prayerTimes.fajr
                ),
                (
                    "dhuhr",
                    String(localized: "dhuhr"),
                    String(localized: "notification_body_dhuhr"),
                    miqatData.dhuhr,
                    prayerTimes.dhuhr
                ),
                (
                    "asr",
                    String(localized: "asr"),
                    String(localized: "notification_body_asr"),
                    miqatData.asr,
                    prayerTimes.asr
                ),
                (
                    "maghrib",
                    String(localized: "maghrib"),
                    String(localized: "notification_body_maghrib"),
                    miqatData.maghrib,
                    prayerTimes.maghrib
                ),
                (
                    "ishaa",
                    String(localized: "ishaa"),
                    String(localized: "notification_body_ishaa"),
                    miqatData.ishaa,
                    prayerTimes.ishaa
                ),
            ]

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let dateString = dateFormatter.string(from: date)

            for prayer in prayers where prayer.enabled && prayer.date > .now {
                let content = UNMutableNotificationContent()
                content.title = prayer.title
                content.body = prayer.body
                content.sound = UNNotificationSound(named: UNNotificationSoundName("azan.caf"))

                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: prayer.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let identifier = "prayertimes-\(prayer.name.lowercased())-\(dateString)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                try? await center.add(request)
            }
        }
    }
}

@DependencyClient
struct PrayerTimesNotificationScheduler: Sendable {
    var scheduleNotifications: @Sendable () async -> Void
    var registerBackgroundTask: @Sendable () -> Void
}

extension PrayerTimesNotificationScheduler: DependencyKey {
    static let liveValue = {
        let service = PrayerTimesNotificationService()
        return PrayerTimesNotificationScheduler(
            scheduleNotifications: { await service.scheduleNotifications() },
            registerBackgroundTask: { service.registerBackgroundTask() }
        )
    }()
}

extension PrayerTimesNotificationScheduler {
    static let testValue = PrayerTimesNotificationScheduler()
}

extension DependencyValues {
    var prayerTimesNotificationScheduler: PrayerTimesNotificationScheduler {
        get { self[PrayerTimesNotificationScheduler.self] }
        set { self[PrayerTimesNotificationScheduler.self] = newValue }
    }
}

