//
//  FeatureFlag.swift
//  PublicSector
//
//  Created by Hamza Jadid on 20/12/2024.
//

struct FeatureFlag: Equatable {
    let key: FeatureFlagKey
    let isOverride: Bool
    let value: Bool
}
