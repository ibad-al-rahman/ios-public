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

    public var display: String {
        switch self {
        case .prayerTimesWeeklyView: "Prayer times weekly view"
        case .prayerTimesOffset: "Prayer times offset"
        case .prayerTimesEvents: "Prayer times events"
        case .prayerTimesShare: "Prayer times share"
        case .adhkarScreen: "Adhkar screen"
        case .settingsRateUs: "Settings rate us"
        case .settingsInviteFriends: "Settings invite friends"
        }
    }

    public var description: String {
        switch self {
        case .prayerTimesWeeklyView: "Enable weekly view"
        case .prayerTimesOffset: "Enabled prayer times offset feature"
        case .prayerTimesEvents: "Enable events and holidays section"
        case .prayerTimesShare: "Enable sharing prayer times"
        case .adhkarScreen: "Enable adhkar screen"
        case .settingsRateUs: "Show rate us in settings"
        case .settingsInviteFriends: "Show invite your friends in settings"
        }
    }
}

public extension [FeatureFlagKey: Bool] {
    static var `default`: [FeatureFlagKey: Bool] {
        [
            .prayerTimesWeeklyView: true,
            .prayerTimesOffset: false,
            .prayerTimesEvents: true,
            .prayerTimesShare: true,
            .adhkarScreen: false,
            .settingsRateUs: false,
            .settingsInviteFriends: false
        ]
    }
}
