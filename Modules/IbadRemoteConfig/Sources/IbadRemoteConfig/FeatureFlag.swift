//
//  FeatureFlag.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

public struct FeatureFlag: Equatable, Identifiable {
    public let key: FeatureFlagKey
    public let value: Bool

    public var id: String { key.rawValue }
}
