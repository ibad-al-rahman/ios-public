//
//  DhikrView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture
import IbadDesign
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

            verseText
                .font(verseFont)
                .multilineTextAlignment(.center)
                .lineSpacing(Spacing.small)
                .foregroundStyle(Color.Ibad.textPrimary)
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

    /// The verse text. For Quranic passages, each numbered ayah is followed by
    /// its Mushaf-style ornate verse marker (﴾١﴿) and flows inline; the
    /// un-numbered opening lines (the Basmalah and Āyat al-Kursī's isti'ādhah)
    /// sit on their own line above the verse body. Plain adhkar render as-is.
    private var verseText: Text {
        let dhikr = store.dhikr
        guard !dhikr.ayat.isEmpty else {
            return Text(verbatim: dhikr.arabicText)
        }
        return dhikr.ayat.reduce(Text(verbatim: "")) { result, ayah in
            guard let number = ayah.number else {
                // Un-numbered opening line: place it on its own line.
                return result + Text(verbatim: ayah.text) + Text(verbatim: "\n")
            }
            return result + Text(verbatim: ayah.text) + Text(verbatim: " \(AyahNumber.formatted(number)) ")
        }
    }

    /// The Quranic (KFGQPC) face for verses; the serif system font for
    /// non-verse adhkar.
    private var verseFont: Font {
        if store.dhikr.isVerse {
            .quranic(.verse)
        } else {
            .system(.title2, design: .serif)
        }
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
                .foregroundStyle(Color.Ibad.textSecondary)

            Text("dhikr_next_hint")
                .font(.footnote)
                .foregroundStyle(Color.Ibad.textTertiary)
        }
    }

    private var countBlock: some View {
        VStack(spacing: Spacing.extraSmall) {
            Text(verbatim: "\(store.count)")
                .font(.ibad(.system, .counter, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(Color.Ibad.textPrimary)
                .contentTransition(.numericText())

            Text(verbatim: "/ \(store.dhikr.target)")
                .font(.headline)
                .foregroundStyle(Color.Ibad.textSecondary)

            Text("dhikr_count_hint")
                .font(.footnote)
                .foregroundStyle(Color.Ibad.textTertiary)
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
