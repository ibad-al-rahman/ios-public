//
//  View+FeatureFlag.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

import Dependencies
import SwiftUI

public extension View {
    @ViewBuilder
    func featureFlagged(_ key: FeatureFlagKey, expected: Bool = true) -> some View {
        @Dependency(\.remoteConfig) var remoteConfig

        if remoteConfig.isFlagEnabled(key: key) == expected {
            self
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    func featureFlagged(oneOf keys: FeatureFlagKey..., expected: Bool = true) -> some View {
        @Dependency(\.remoteConfig) var remoteConfig

        if keys.first(where: { remoteConfig.isFlagEnabled($0) == expected }) != nil {
            self
        } else {
            EmptyView()
        }
    }
}
