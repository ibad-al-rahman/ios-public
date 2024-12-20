// The Swift Programming Language
// https://docs.swift.org/swift-book

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct RemoteConfig: Sendable {
    public var isFlagEnabled: @Sendable (
        _ key: FeatureFlagKey
    ) -> Bool = { _ in false }

    public var setFlag: @Sendable (
        _ key: FeatureFlagKey, _ newValue: Bool
    ) -> Void

    public var allFeatureFlags: @Sendable () -> [FeatureFlag] = { [] }
}

extension RemoteConfig: DependencyKey {
    public static var liveValue: RemoteConfig {
        let manager = RemoteConfigManager()

        return RemoteConfig(
            isFlagEnabled: { manager.isFlagEnabled(key: $0) },
            setFlag: { manager.setFlag(key: $0, newValue: $1) },
            allFeatureFlags: { manager.allFeatureFlags() }
        )
    }
}

extension RemoteConfig: TestDependencyKey {
    public static var previewValue: RemoteConfig {
        RemoteConfig()
    }

    public static var testValue: RemoteConfig {
        RemoteConfig()
    }
}

public extension DependencyValues {
    var remoteConfig: RemoteConfig {
        get { self[RemoteConfig.self] }
        set { self[RemoteConfig.self] = newValue }
    }
}
