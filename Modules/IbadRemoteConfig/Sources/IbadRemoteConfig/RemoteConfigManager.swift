//
//  RemoteConfigManager.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

import Dependencies
import FirebaseRemoteConfig
import Foundation
import Sharing

/// `@unchecked Sendable`: the only non-Sendable stored property is Firebase's
/// `RemoteConfig`, whose shared instance is documented as safe for concurrent access.
struct RemoteConfigManager: @unchecked Sendable {
    @Shared(.featureFlags) private var featureFlags = .default
    private let remoteConfig: FirebaseRemoteConfig.RemoteConfig

    init() {
        self.remoteConfig = FirebaseRemoteConfig.RemoteConfig.remoteConfig()

        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 60
        self.remoteConfig.configSettings = settings

        let defaults = FeatureFlagKey.allCases.reduce(into: [String: NSObject]()) { defaults, key in
            let value = FeatureFlagDict.default[key] ?? false
            defaults[key.rawValue] = value as NSObject
        }
        self.remoteConfig.setDefaults(defaults)

        self.remoteConfig.fetchAndActivate { _, error in
            if let error {
                print("Failed to fetch remote config: \(error)")
            }
        }
    }

    func isFlagEnabled(key: FeatureFlagKey) -> Bool {
#if !(RELEASE)
        if let enablement = featureFlags[key] {
            return enablement
        }
#endif
        return self.remoteConfig[key.rawValue].boolValue
    }

    func setFlag(key: FeatureFlagKey, newValue: Bool) {
        if newValue == self.remoteConfig[key.rawValue].boolValue {
            $featureFlags.withLock { $0[key] = FeatureFlagDict.default[key] }
        } else {
            $featureFlags.withLock { $0[key] = newValue }
        }
    }

    func resetFlags() {
        $featureFlags.withLock { $0 = .default }
    }

    func allFeatureFlags() -> [FeatureFlag] {
        FeatureFlagKey.allCases.map { FeatureFlag(key: $0, value: isFlagEnabled(key: $0)) }
    }
}
