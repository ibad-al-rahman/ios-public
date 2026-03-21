//
//  PrayerTimesNotificationScheduler.swift
//  PublicSector
//
//  Created by Hamza Jadid on 19/03/2026.
//

import Dependencies
import DependenciesMacros
import IbadRemoteConfig
import Foundation
import MiqatKit
import Sharing
import UserNotifications

struct PrayerTimesNotificationService {
    public func scheduleNotifications() async {
        @Shared(.notificationsEnabled) var notificationsEnabled = false
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

        @Shared(.fajrNotificationEnabled) var fajrEnabled = false
        @Shared(.dhuhrNotificationEnabled) var dhuhrEnabled = false
        @Shared(.asrNotificationEnabled) var asrEnabled = false
        @Shared(.maghribNotificationEnabled) var maghribEnabled = false
        @Shared(.ishaaNotificationEnabled) var ishaaEnabled = false

        let tzOffset = TimeZone.current.secondsFromGMT()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        for dayOffset in 0 ..< 7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            let timestamp = date.timeIntervalSince1970 + TimeInterval(tzOffset)
            let miqatData = miqatService.getMiqatData(timestampSecs: timestamp, provider: .darElFatwa(.beirut))

            let prayers: [(name: String, date: Date, enabled: Bool)] = [
                ("Fajr", miqatData.fajr, fajrEnabled),
                ("Dhuhr", miqatData.dhuhr, dhuhrEnabled),
                ("Asr", miqatData.asr, asrEnabled),
                ("Maghrib", miqatData.maghrib, maghribEnabled),
                ("Ishaa", miqatData.ishaa, ishaaEnabled),
            ]

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let dateString = dateFormatter.string(from: date)

            for prayer in prayers where prayer.enabled && prayer.date > .now {
                let content = UNMutableNotificationContent()
                content.title = prayer.name
                content.body = "It's time for \(prayer.name) prayer"
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
    var bgScheduleNotifications: @Sendable () async -> Void
}

extension PrayerTimesNotificationScheduler: DependencyKey {
    static let liveValue = {
        let service = PrayerTimesNotificationService()
        return PrayerTimesNotificationScheduler(
            scheduleNotifications: { await service.scheduleNotifications() },
            bgScheduleNotifications: {}
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

