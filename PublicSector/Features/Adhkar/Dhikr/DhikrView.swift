//
//  DhikrView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture
import SwiftUI

/// A single dhikr: its Arabic text centered on screen, with a repetition counter
/// below that flips to a done state once the target is reached. Tapping increments
/// the count while counting, or (once done) asks the tour to advance; the child
/// reducer decides which, and the hosting tour owns navigation between adhkar.
struct DhikrView: View {
    let store: StoreOf<DhikrFeature>

    var body: some View {
        VStack(spacing: Spacing.none) {
            Spacer(minLength: Spacing.large)

            Text(verbatim: store.dhikr.arabicText)
                .font(.system(.title2, design: .serif))
                .multilineTextAlignment(.center)
                .lineSpacing(Spacing.small)
                .foregroundStyle(.primary)
                .padding(.horizontal, Spacing.large)
                .frame(maxWidth: .infinity)

            Spacer(minLength: Spacing.large)

            bottomBlock
                .padding(.bottom, Spacing.extraLarge)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { store.send(.view(.tapped), animation: .snappy) }
    }

    @ViewBuilder
    private var bottomBlock: some View {
        if store.isComplete {
            doneBlock
        } else {
            countBlock
        }
    }

    private var doneBlock: some View {
        VStack(spacing: Spacing.small) {
            CompletionMark(size: 64)

            Text("dhikr_done")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("dhikr_next_hint")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
    }

    private var countBlock: some View {
        VStack(spacing: Spacing.extraSmall) {
            Text(verbatim: "\(store.count)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .contentTransition(.numericText())

            HStack(spacing: Spacing.extraSmall) {
                Text(verbatim: "\(store.dhikr.target)")
                Text("dhikr_times")
            }
            .font(.headline)
            .foregroundStyle(.secondary)

            Text("dhikr_count_hint")
                .font(.footnote)
                .foregroundStyle(.tertiary)
                .padding(.top, Spacing.small)
        }
    }
}

#Preview {
    DhikrView(store: Store(
        initialState: DhikrFeature.State(dhikr: AdhkarCollection.morning.adhkar[0]),
        reducer: DhikrFeature.init
    ))
}

#Preview {
    DhikrView(store: Store(
        initialState: DhikrFeature.State(dhikr: AdhkarCollection.morning.adhkar[0]),
        reducer: DhikrFeature.init
    ))
    .arabicEnvironment()
}
