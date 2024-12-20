//
//  FeatureFlagView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 20/12/2024.
//

import ComposableArchitecture
import SwiftUI

struct FeatureFlagView: View {
    let store: StoreOf<FeatureFlagFeature>

    var body: some View {
        Text(verbatim: "Feature Flags")
    }
}
