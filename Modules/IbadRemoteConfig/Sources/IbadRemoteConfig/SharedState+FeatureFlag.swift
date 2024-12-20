//
//  SharedState+FeatureFlag.swift
//  IbadRemoteConfig
//
//  Created by Hamza Jadid on 20/12/2024.
//

import Foundation
import Sharing

extension SharedKey where Self == FileStorageKey<[FeatureFlagKey: Bool]> {
    static var featureFlags: Self {
        fileStorage(
            .documentsDirectory.appending(component: "featureFlags.json")
        )
    }
}
