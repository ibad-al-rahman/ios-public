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

    public var toggleFlag: @Sendable (
        _ key: FeatureFlagKey
    ) -> Void
}

extension RemoteConfig: DependencyKey {
    public static var liveValue: RemoteConfig {
        let manager = RemoteConfigManager()

        return RemoteConfig(
            isFlagEnabled: { manager.isFlagEnabled(key: $0) },
            toggleFlag: { manager.toggleFlag(key: $0) }
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
