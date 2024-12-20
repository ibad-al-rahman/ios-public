//
//  FeatureFlagKey.swift
//  PublicSector
//
//  Created by Hamza Jadid on 20/12/2024.
//

enum FeatureFlagKey: String, Codable, CaseIterable {
    case prayerTimesWeeklyView = "ff_ios_prayerTimes_weeklyView"
    case adhkarScreen = "ff_ios_adhkar_screen"

    var defaultValue: Bool { false }
}
