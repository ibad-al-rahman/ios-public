//
//  TourProgressBar.swift
//  PublicSector
//
//  Created by Hamza Jadid on 05/07/2026.
//

import SwiftUI

/// A thin horizontal progress bar: a dim track with an accent-colored fill.
/// The leading-aligned fill flips automatically under right-to-left layout.
struct TourProgressBar: View {
    /// Progress fraction, clamped to `0...1`.
    let progress: Double
    var height: CGFloat = 4

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.2))

                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: geometry.size.width * min(max(progress, 0), 1))
            }
        }
        .frame(height: height)
        .animation(.snappy, value: progress)
    }
}

#Preview {
    VStack(spacing: Spacing.large) {
        TourProgressBar(progress: 0)
        TourProgressBar(progress: 0.5)
        TourProgressBar(progress: 1)
    }
    .padding(Spacing.large)
}
