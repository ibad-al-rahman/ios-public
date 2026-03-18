//
//  FeatureFlagKey.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

public enum FeatureFlagKey: String, Codable, CaseIterable, Sendable {
    case adhkarScreen = "ff_apple_adhkar_screen"
    case eventsScreen = "ff_apple_events_screen"
    case forceUpdate = "ff_mobile_forceUpdate"

    public var display: String {
        switch self {
        case .adhkarScreen: "Adhkar screen"
        case .eventsScreen: "Events screen"
        case .forceUpdate: "Force update"
        }
    }

    public var description: String {
        switch self {
        case .adhkarScreen: "Enable adhkar screen"
        case .eventsScreen: "Enable events screen"
        case .forceUpdate: "Enable force update screen"
        }
    }
}
