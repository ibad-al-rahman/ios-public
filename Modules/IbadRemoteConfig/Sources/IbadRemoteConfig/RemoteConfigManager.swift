//
//  RemoteConfigManager.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

import Sharing

struct RemoteConfigManager {
    @Shared(.featureFlags) private var featureFlags = .default

    func isFlagEnabled(key: FeatureFlagKey) -> Bool {
        guard let value = featureFlags[key] else { return false }
        return value
    }

    func setFlag(key: FeatureFlagKey, newValue: Bool) {
        $featureFlags.withLock { $0[key] = newValue }
    }

    func resetFlags() {
        $featureFlags.withLock { $0 = .default }
    }

    func allFeatureFlags() -> [FeatureFlag] {
        featureFlags.map { FeatureFlag(key: $0.key, value: $0.value) }
    }
}
