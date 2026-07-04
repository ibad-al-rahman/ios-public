//
//  DhikrView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture
import SwiftUI

/// Minimal placeholder UI for a single dhikr. Design is intentionally bare —
/// it will be reworked once the visual direction is settled.
struct DhikrView: View {
    let store: StoreOf<DhikrFeature>

    var body: some View {
        VStack(spacing: Spacing.extraLarge) {
            Text(verbatim: store.dhikr.arabicText)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.large)

            Text(verbatim: "\(store.count) / \(store.dhikr.target)")
                .font(.headline)
                .monospacedDigit()
                .foregroundStyle(.secondary)

            Button {
                store.send(.view(.incrementTapped))
            } label: {
                Image(systemName: "hand.tap")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.bordered)
            .padding(.horizontal, Spacing.large)
        }
    }
}

#Preview {
    DhikrView(store: Store(
        initialState: DhikrFeature.State(dhikr: Adhkar.morning[0]),
        reducer: DhikrFeature.init
    ))
}

#Preview {
    DhikrView(store: Store(
        initialState: DhikrFeature.State(dhikr: Adhkar.morning[0]),
        reducer: DhikrFeature.init
    ))
    .arabicEnvironment()
}
