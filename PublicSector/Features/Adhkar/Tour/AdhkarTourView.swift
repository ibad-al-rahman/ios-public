//
//  AdhkarTourView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture
import SwiftUI

/// Minimal placeholder UI for the tour. Shows the active dhikr, or a completion
/// state once every dhikr is done. Design is intentionally bare for now.
struct AdhkarTourView: View {
    let store: StoreOf<AdhkarTourFeature>

    var body: some View {
        VStack(spacing: Spacing.large) {
            Text(verbatim: "\(store.completedCount) / \(store.total)")
                .font(.subheadline)
                .monospacedDigit()
                .foregroundStyle(.secondary)

            content
        }
        .padding(.vertical, Spacing.large)
    }

    @ViewBuilder
    private var content: some View {
        if let id = store.activeID,
           let childStore = store.scope(
               state: \.dhikrStates[id: id],
               action: \.dependent.dhikr[id: id]
           ) {
            DhikrView(store: childStore)
        } else {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)
                .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    AdhkarTourView(store: Store(
        initialState: AdhkarTourFeature.State(adhkar: Adhkar.morning),
        reducer: AdhkarTourFeature.init
    ))
}

#Preview {
    AdhkarTourView(store: Store(
        initialState: AdhkarTourFeature.State(adhkar: Adhkar.morning),
        reducer: AdhkarTourFeature.init
    ))
    .arabicEnvironment()
}
