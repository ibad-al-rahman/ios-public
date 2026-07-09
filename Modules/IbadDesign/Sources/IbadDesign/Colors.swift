//
//  Colors.swift
//  IbadDesign
//
//  Semantic color tokens defined purely in Swift with explicit light/dark
//  values (no asset catalog). Each token resolves through a dynamic
//  `UIColor` provider so it flips with the trait environment.
//

import SwiftUI
import UIKit

extension Color {
    /// A color with distinct light and dark appearances, resolved dynamically
    /// from the trait environment.
    public init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            switch traits.userInterfaceStyle {
            case .dark: UIColor(dark)
            default: UIColor(light)
            }
        })
    }

    /// The design system's semantic color palette.
    public enum Ibad {
        /// Primary text.
        public static let textPrimary = Color(
            light: Color(.sRGB, red: 0, green: 0, blue: 0),
            dark: Color(.sRGB, red: 1, green: 1, blue: 1)
        )

        /// Secondary / supporting text.
        public static let textSecondary = Color(
            light: Color(.sRGB, red: 0.24, green: 0.24, blue: 0.26, opacity: 0.6),
            dark: Color(.sRGB, red: 0.92, green: 0.92, blue: 0.96, opacity: 0.6)
        )

        /// Tertiary / hint text.
        public static let textTertiary = Color(
            light: Color(.sRGB, red: 0.24, green: 0.24, blue: 0.26, opacity: 0.3),
            dark: Color(.sRGB, red: 0.92, green: 0.92, blue: 0.96, opacity: 0.3)
        )

        /// Brand accent. Seeded from the app's `AccentColor` asset.
        public static let accent = Color(
            light: Color(.sRGB, red: 0.118, green: 0.223, blue: 0.549),
            dark: Color(.sRGB, red: 0.020, green: 0.592, blue: 0.690)
        )

        /// Screen background. Seeded from the app's `Background` asset.
        public static let background = Color(
            light: Color(.sRGB, red: 1, green: 1, blue: 1),
            dark: Color(.sRGB, red: 0x12 / 255, green: 0x12 / 255, blue: 0x12 / 255)
        )
    }
}
