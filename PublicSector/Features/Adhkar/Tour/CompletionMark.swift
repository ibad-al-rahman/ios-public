//
//  CompletionMark.swift
//  PublicSector
//
//  Created by Hamza Jadid on 05/07/2026.
//

import SwiftUI

/// An accent-colored check mark inside a ringed circle. Used both for a completed
/// dhikr's done state and for the tour completion screen; the `size` scales it.
struct CompletionMark: View {
    var size: CGFloat = 72

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor.opacity(0.15))

            Circle()
                .stroke(Color.accentColor, lineWidth: size * 0.03)

            Image(systemName: "checkmark")
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundStyle(Color.accentColor)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack(spacing: Spacing.large) {
        CompletionMark(size: 64)
        CompletionMark(size: 120)
    }
    .padding(Spacing.large)
}
