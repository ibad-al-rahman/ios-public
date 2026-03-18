//
//  FeatureFlagKey.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

public enum FeatureFlagKey: String, Codable, CaseIterable, Sendable {
    case forceUpdate = "ff_mobile_forceUpdate"
    case adhkarScreen = "ff_apple_adhkar_screen"
    case eventsScreen = "ff_apple_events_screen"
    case prayerTimesNotifications = "ff_apple_prayerTimes_notifications"

    public var display: String {
        switch self {
        case .forceUpdate: "Force update"
        case .adhkarScreen: "Adhkar screen"
        case .eventsScreen: "Events screen"
        case .prayerTimesNotifications: "Prayer time notifications"
        }
    }

    public var description: String {
        switch self {
        case .forceUpdate: "Enable force update screen"
        case .adhkarScreen: "Enable adhkar screen"
        case .eventsScreen: "Enable events screen"
        case .prayerTimesNotifications: "Enable prayer times notifications"
        }
    }
}
