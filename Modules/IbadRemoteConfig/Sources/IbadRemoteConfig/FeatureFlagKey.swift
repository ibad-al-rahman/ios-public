//
//  FeatureFlagKey.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

public enum FeatureFlagKey: String, Codable, CaseIterable, Sendable {
    case adhkarScreen = "ff_apple_adhkar_screen"
    case eventsScreen = "ff_apple_events_screen"

    public var display: String {
        switch self {
        case .adhkarScreen: "Adhkar screen"
        case .eventsScreen: "Events screen"
        }
    }

    public var description: String {
        switch self {
        case .adhkarScreen: "Enable adhkar screen"
        case .eventsScreen: "Enable events screen"
        }
    }
}

public extension [FeatureFlagKey: Bool] {
    static var `default`: [FeatureFlagKey: Bool] {
        [
            .adhkarScreen: false,
            .eventsScreen: false
        ]
    }
}
