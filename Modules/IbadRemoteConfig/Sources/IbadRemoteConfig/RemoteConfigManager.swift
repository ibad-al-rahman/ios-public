//
//  RemoteConfigManager.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

import Foundation
import Pmff
import Sharing

struct RemoteConfigManager {
    @Shared(.featureFlags) private var featureFlags = .default
    private let pmffClient: RemoteFeatureFlagClient

    init() {
        self.pmffClient = RemoteFeatureFlagClient(
            url: URL(string: "https://ibad-al-rahman.github.io/remote-config/flags.json")!,
            refreshInterval: 10
        )
        self.pmffClient.start()
    }

    func isFlagEnabled(key: FeatureFlagKey) -> Bool {
        self.pmffClient.isEnabled(key.rawValue)
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
