//
//  FeatureFlagKey.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

public enum FeatureFlagKey: String, Codable, CaseIterable, Sendable {
    case prayerTimesWeeklyView = "ff_apple_prayerTimes_weeklyView"
    case adhkarScreen = "ff_apple_adhkar_screen"
}

public extension [FeatureFlagKey: Bool] {
    static var `default`: [FeatureFlagKey: Bool] {
        [
            .prayerTimesWeeklyView: false,
            .adhkarScreen: false
        ]
    }
}
