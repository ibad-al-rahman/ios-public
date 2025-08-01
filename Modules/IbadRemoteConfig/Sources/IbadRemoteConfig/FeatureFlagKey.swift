//
//  FeatureFlagKey.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

public enum FeatureFlagKey: String, Codable, CaseIterable, Sendable {
    case prayerTimesOffset = "ff_apple_prayerTimes_offset"
    case adhkarScreen = "ff_apple_adhkar_screen"

    public var display: String {
        switch self {
        case .prayerTimesOffset: "Prayer times offset"
        case .adhkarScreen: "Adhkar screen"
        }
    }

    public var description: String {
        switch self {
        case .prayerTimesOffset: "Enabled prayer times offset feature"
        case .adhkarScreen: "Enable adhkar screen"
        }
    }
}

public extension [FeatureFlagKey: Bool] {
    static var `default`: [FeatureFlagKey: Bool] {
        [
            .prayerTimesOffset: false,
            .adhkarScreen: false
        ]
    }
}
