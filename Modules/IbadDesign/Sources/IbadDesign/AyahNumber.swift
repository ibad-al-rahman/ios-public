//
//  AyahNumber.swift
//  IbadDesign
//
//  Formats a verse (ayah) number the way it appears in a printed Mushaf, using
//  the ornate "flower" brackets (U+FD3E / U+FD3F) around Arabic-Indic digits —
//  e.g. `﴾١﴿`. This is the fallback the KFGQPC (Uthman Taha Naskh) font supports:
//  it lacks the circular end-of-ayah glyph (U+06DD) but contains both the
//  ornate parentheses and the Arabic-Indic digits.
//

import Foundation

/// Formatting helpers for Quranic verse numbers.
public enum AyahNumber {
    /// U+FD3E ORNATE LEFT PARENTHESIS ﴾ — glyph opens toward the right, so in a
    /// right-to-left line it belongs at the *end* of the logical string.
    private static let ornateLeft = "\u{FD3E}"
    /// U+FD3F ORNATE RIGHT PARENTHESIS ﴿ — glyph opens toward the left, so in a
    /// right-to-left line it belongs at the *start* of the logical string.
    private static let ornateRight = "\u{FD3F}"
    /// U+2067 RIGHT-TO-LEFT ISOLATE — opens an isolated RTL run.
    private static let rtlIsolate = "\u{2067}"
    /// U+2069 POP DIRECTIONAL ISOLATE — closes the isolated run.
    private static let popIsolate = "\u{2069}"

    /// The verse number wrapped in ornate brackets with Arabic-Indic digits,
    /// e.g. `formatted(2)` → `﴾٢﴿`.
    ///
    /// The brackets are Other-Neutral and *not* bidi-mirrored, so their glyph
    /// shapes are fixed. To render `﴾…﴿` (opening on the reader's right) in a
    /// right-to-left line the logical order must be right-bracket, digits,
    /// left-bracket. The whole thing is wrapped in an RTL isolate so it lays out
    /// correctly regardless of the surrounding run.
    ///
    /// - Parameter number: the ayah number (1-based).
    public static func formatted(_ number: Int) -> String {
        "\(rtlIsolate)\(ornateRight)\(arabicIndicDigits(number))\(ornateLeft)\(popIsolate)"
    }

    /// A non-negative integer rendered with Arabic-Indic digits (U+0660–0669),
    /// e.g. `arabicIndicDigits(25)` → `٢٥`.
    public static func arabicIndicDigits(_ number: Int) -> String {
        // U+0660 (٠) is offset 0x0630 above U+0030 (0); shift each ASCII digit.
        let asciiZero: UInt32 = 0x30
        let arabicZero: UInt32 = 0x0660
        return String(abs(number)).unicodeScalars.reduce(into: "") { result, scalar in
            let arabic = Unicode.Scalar(scalar.value - asciiZero + arabicZero) ?? scalar
            result.unicodeScalars.append(arabic)
        }
    }
}
