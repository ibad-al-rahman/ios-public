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
