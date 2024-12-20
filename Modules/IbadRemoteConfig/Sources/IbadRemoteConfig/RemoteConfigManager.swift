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

    func toggleFlag(key: FeatureFlagKey) {
        $featureFlags.withLock { $0[key]?.toggle() }
    }
}
