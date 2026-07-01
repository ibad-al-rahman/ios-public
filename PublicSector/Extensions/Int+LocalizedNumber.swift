//
//  Int+LocalizedNumber.swift
//  PublicSector
//
//  Created by Hamza Jadid on 01/07/2026.
//

import Foundation

extension Int {
    /// Formats the integer using the given locale's number system
    /// (e.g. Arabic-Indic numerals under `ar`, Western digits under `en`),
    /// without any grouping separator.
    /// - Parameters:
    ///   - locale: The locale whose number system to use.
    ///   - minimumDigits: Zero-pads the result to at least this many digits
    ///     before localizing (e.g. `5` → `05` → `٠٥`).
    func localizedNumber(locale: Locale, minimumDigits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = false
        formatter.minimumIntegerDigits = minimumDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
