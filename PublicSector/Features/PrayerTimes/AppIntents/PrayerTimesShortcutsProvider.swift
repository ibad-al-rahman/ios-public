//
//  PrayerTimesShortcutsProvider.swift
//  PublicSector
//
//  Created by Hamza Jadid on 02/09/2026.
//

import AppIntents

/// Surfaces the prayer-time intent in the Shortcuts app and to Siri.
struct PrayerTimesShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GetPrayerTimeIntent(),
            phrases: [
                "Get prayer time in \(.applicationName)",
                "What time is the prayer in \(.applicationName)",
            ],
            shortTitle: "Prayer Time",
            systemImageName: "moon.stars"
        )
    }
}
