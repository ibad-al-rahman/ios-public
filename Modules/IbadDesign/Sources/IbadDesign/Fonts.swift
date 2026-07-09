//
//  Fonts.swift
//  IbadDesign
//
//  Font-family tokens plus a size scale. Views compose a family, a size, and a
//  weight rather than reaching for `Font.custom(...)` / `Font.system(...)`
//  directly, so the "Arabic Quranic script vs. system face" decision lives in
//  one place.
//
//  Requires `IbadDesign.registerFonts()` to have been called at startup for the
//  `.quranic` family to resolve.
//

import SwiftUI

/// A typeface family exposed by the design system.
public enum FontFamily {
    /// The KFGQPC Uthman Taha Naskh face — the proper Uthmanic script for
    /// Quranic verses and Arabic numerals.
    case quranic
    /// The platform system font.
    case system
}

/// The design system's type-size scale. Mirrors the `Spacing` enum style:
/// typed cases carrying a raw point value. Only the sizes currently used by
/// the app are listed — extend deliberately.
public enum TypeScale: CGFloat {
    /// footnote = 13
    case footnote = 13
    /// subheadline = 15
    case subheadline = 15
    /// headline = 17
    case headline = 17
    /// verse = 22 — Quranic / adhkar body text.
    case verse = 22
    /// counter = 72 — the large repetition counter.
    case counter = 72
}

extension Font {
    /// Builds a font from a family, a size, and a weight.
    ///
    /// - Parameters:
    ///   - family: the typeface family.
    ///   - size: the point size.
    ///   - weight: the desired weight. For `.quranic`, only regular vs. bold
    ///     faces exist, so anything `.semibold` or heavier maps to the bold
    ///     face and everything lighter to the regular face.
    ///   - design: the system font design (ignored for `.quranic`).
    public static func ibad(
        _ family: FontFamily,
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> Font {
        switch family {
        case .quranic:
            let name = weight.isBoldish
                ? IbadDesign.FontName.quranicBold
                : IbadDesign.FontName.quranicRegular
            return .custom(name, size: size)
        case .system:
            return .system(size: size, weight: weight, design: design)
        }
    }

    /// Convenience for a family + a scale token.
    public static func ibad(
        _ family: FontFamily,
        _ scale: TypeScale,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> Font {
        ibad(family, size: scale.rawValue, weight: weight, design: design)
    }

    /// The Quranic (KFGQPC) face at an explicit size.
    public static func quranic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        ibad(.quranic, size: size, weight: weight)
    }

    /// The Quranic (KFGQPC) face at a scale token.
    public static func quranic(_ scale: TypeScale, weight: Font.Weight = .regular) -> Font {
        ibad(.quranic, scale, weight: weight)
    }
}

extension Font.Weight {
    /// Whether this weight should fold onto the bold Quranic face (the KFGQPC
    /// font ships only regular and bold cuts). `.semibold` and heavier count as
    /// bold; everything lighter uses the regular face.
    fileprivate var isBoldish: Bool {
        switch self {
        case .semibold, .bold, .heavy, .black: true
        default: false
        }
    }
}
