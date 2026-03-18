//
//  FeatureFlagDict.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 18/03/2026.
//

typealias FeatureFlagDict = [FeatureFlagKey: Bool]

public extension FeatureFlagDict {
    static var `default`: [FeatureFlagKey: Bool] {
#if RELEASE
        [:]
#else
        [.forceUpdate: false]
#endif
    }
}
