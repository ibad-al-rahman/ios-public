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
    struct PrayerTimesNotifications: Codable, Equatable {
        var fajr: Bool = false
        var dhuhr: Bool = false
        var asr: Bool = false
        var maghrib: Bool = false
        var ishaa: Bool = false
    }
}

extension Settings {
    struct AdhkarNotifications: Codable, Equatable {
        var morningEnabled: Bool = false
        var eveningEnabled: Bool = false
        var morningTime: DateComponents = DateComponents(hour: 6, minute: 0)
        var eveningTime: DateComponents = DateComponents(hour: 18, minute: 0)
    }
}

extension Binding where Value == DateComponents {
    /// Bridges hour/minute `DateComponents` to a `Binding<Date>` for use with a `DatePicker`,
    /// storing back only the hour and minute so the reminder time is timezone/day agnostic.
    var date: Binding<Date> {
        Binding<Date>(
            get: { Calendar.current.date(from: wrappedValue) ?? Calendar.current.startOfDay(for: .now) },
            set: { wrappedValue = Calendar.current.dateComponents([.hour, .minute], from: $0) }
        )
    }
}

extension Settings {
    struct SelectedLocation: Codable, Equatable {
        var name: String
        var latitude: Double
        var longitude: Double
    }
}

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
