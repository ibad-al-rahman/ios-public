//
//  AdhkarTourView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture
import SwiftUI

/// Walks the user through a set of adhkar one dhikr at a time. Shows a header
/// with the tour position and title over a progress bar, hosts the active
/// `DhikrView`, and owns swipe navigation between adhkar. Once every dhikr is
/// done it shows a completion state.
struct AdhkarTourView: View {
    let store: StoreOf<AdhkarTourFeature>
    @Environment(\.layoutDirection) private var layoutDirection

    var body: some View {
        VStack(spacing: Spacing.medium) {
            header
            content
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var header: some View {
        VStack(spacing: Spacing.small) {
            HStack {
                if let index = store.activeIndex {
                    Text(verbatim: "\(index) / \(store.total)")
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(LocalizedStringKey(store.title))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }

            TourProgressBar(progress: progress)
        }
    }

    /// Position through the tour: the active dhikr's index over the total.
    private var progress: Double {
        guard store.total > 0 else { return 0 }
        return Double(store.activeIndex ?? store.total) / Double(store.total)
    }

    @ViewBuilder
    private var content: some View {
        if let id = store.activeID,
           let childStore = store.scope(
               state: \.dhikrStates[id: id],
               action: \.dependent.dhikr[id: id]
           ) {
            DhikrView(store: childStore)
                .id(id)
                .transition(.opacity)
                .contentShape(Rectangle())
                .gesture(swipeGesture)
        } else {
            completionScreen
        }
    }

    private var completionScreen: some View {
        VStack(spacing: Spacing.large) {
            CompletionMark(size: 120)

            Text(verbatim: completionText)
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { store.send(.view(.finishTapped)) }
    }

    /// "تمّت {collection name}" — the completion template filled with the localized
    /// collection name.
    private var completionText: String {
        String(
            format: String(localized: "adhkar_completed"),
            String(localized: String.LocalizationValue(store.title))
        )
    }

    /// Horizontal swipe navigation. Under right-to-left layout the direction is
    /// mirrored so swiping toward the reading direction advances the tour.
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onEnded { value in
                let dx = value.translation.width
                guard abs(dx) > 60 else { return }
                let forward = layoutDirection == .rightToLeft ? dx > 0 : dx < 0
                store.send(.view(forward ? .nextTapped : .previousTapped), animation: .snappy)
            }
    }
}

#Preview {
    AdhkarTourView(store: Store(
        initialState: AdhkarTourFeature.State(collection: .morning),
        reducer: AdhkarTourFeature.init
    ))
}

#Preview {
    AdhkarTourView(store: Store(
        initialState: AdhkarTourFeature.State(collection: .morning),
        reducer: AdhkarTourFeature.init
    ))
    .arabicEnvironment()
}
