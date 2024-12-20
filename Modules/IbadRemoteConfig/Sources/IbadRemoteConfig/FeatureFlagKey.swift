//
//  FeatureFlagKey.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

public enum FeatureFlagKey: String, Codable, CaseIterable, Sendable {
    case prayerTimesWeeklyView = "ff_apple_prayerTimes_weeklyView"
    case prayerTimesOffset = "ff_apple_prayerTimes_offset"
    case prayerTimesEvents = "ff_apple_prayerTimes_events"
    case prayerTimesShare = "ff_apple_prayerTimes_share"

    case adhkarScreen = "ff_apple_adhkar_screen"

    case settingsRateUs = "ff_apple_settings_rateUs"
    case settingsInviteFriends = "ff_apple_settings_inviteFriends"
}

public extension [FeatureFlagKey: Bool] {
    static var `default`: [FeatureFlagKey: Bool] {
        [
            .prayerTimesWeeklyView: false,
            .prayerTimesOffset: false,
            .prayerTimesEvents: false,
            .prayerTimesShare: false,
            .adhkarScreen: false,
            .settingsRateUs: false,
            .settingsInviteFriends: false
        ]
    }
}
