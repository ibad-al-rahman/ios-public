//
//  Settings.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import Foundation
import SwiftUI

struct Settings { }

extension Settings {
    enum Appearance: String, CaseIterable, Identifiable {
        case system = "system"
        case light = "light"
        case dark = "dark"

        var id: String { self.rawValue }

        var colorScheme: ColorScheme? {
            switch self {
            case .system: nil
            case .dark: ColorScheme.dark
            case .light: ColorScheme.light
            }
        }
    }
}

extension Settings {
    enum Language: String, CaseIterable, Identifiable {
        case system = "system"
        case arabic = "arabic"
        case english = "english"

        var id: String { self.rawValue }

        var locale: Locale? {
            switch self {
            case .system: nil
            case .arabic: Locale(identifier: "ar")
            case .english: Locale(identifier: "en")
            }
        }

        var layoutDirection: LayoutDirection? {
            switch self {
            case .system: nil
            case .arabic: .rightToLeft
            case .english: .leftToRight
            }
        }
    }
}
