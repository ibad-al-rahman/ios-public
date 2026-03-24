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
        case system
        case light
        case dark

        var id: String { self.rawValue }

        var colorScheme: ColorScheme? {
            switch self {
            case .system: nil
            case .dark: ColorScheme.dark
            case .light: ColorScheme.light
            }
        }

        var localizedStringKey: LocalizedStringKey {
            switch self {
            case .system: "system"
            case .dark: "dark_theme"
            case .light: "light_theme"
            }
        }
    }
}
