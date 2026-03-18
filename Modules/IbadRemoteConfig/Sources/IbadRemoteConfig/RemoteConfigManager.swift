//
//  RemoteConfigManager.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

import Dependencies
import IbadEnvironment
import Foundation
import Pmff
import Sharing

struct RemoteConfigManager {
    @Dependency(\.appDetails) private var appDetails
    @Shared(.featureFlags) private var featureFlags = .default
    private let pmffClient: RemoteFeatureFlagClient

    init() {
        self.pmffClient = RemoteFeatureFlagClient(
            url: URL(string: "https://ibad-al-rahman.github.io/remote-config/flags.json")!,
            refreshInterval: 60
        )
        self.pmffClient.set("appName", value: "ios-public-sector")
        self.pmffClient.set("appVersion", value: appDetails.versionString)
    }

    func isFlagEnabled(key: FeatureFlagKey) -> Bool {
#if !(RELEASE)
        if let enablement = featureFlags[key] {
            return enablement
        }
#endif
        return self.pmffClient.isEnabled(key.rawValue)
    }

    func setFlag(key: FeatureFlagKey, newValue: Bool) {
        if newValue == self.pmffClient.isEnabled(key.rawValue) {
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
