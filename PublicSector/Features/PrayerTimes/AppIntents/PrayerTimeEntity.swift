//
//  PrayerTimeEntity.swift
//  PublicSector
//
//  Created by Hamza Jadid on 02/09/2026.
//

import AppIntents
import Foundation
import MiqatKit

/// The prayer a user picks in the Shortcuts app / Siri when querying a prayer time.
///
/// Only the always-present daily prayers plus sunrise are exposed. Imsak and Eid are
/// intentionally omitted because they are seasonal and would be absent on most days.
enum PrayerTimeEntity: String, AppEnum {
    case fajr
    case sunrise
    case dhuhr
    case asr
    case maghrib
    case ishaa

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Prayer"

    static let caseDisplayRepresentations: [PrayerTimeEntity: DisplayRepresentation] = [
        .fajr: DisplayRepresentation(title: "fajr"),
        .sunrise: DisplayRepresentation(title: "sunrise"),
        .dhuhr: DisplayRepresentation(title: "dhuhr"),
        .asr: DisplayRepresentation(title: "asr"),
        .maghrib: DisplayRepresentation(title: "maghrib"),
        .ishaa: DisplayRepresentation(title: "ishaa"),
    ]

    /// The localized prayer name, reusing the same string keys as the rest of the app.
    var localizedName: String {
        switch self {
        case .fajr: String(localized: "fajr")
        case .sunrise: String(localized: "sunrise")
        case .dhuhr: String(localized: "dhuhr")
        case .asr: String(localized: "asr")
        case .maghrib: String(localized: "maghrib")
        case .ishaa: String(localized: "ishaa")
        }
    }

    /// Extracts this prayer's time from a computed day of prayer times.
    func time(in data: MiqatData) -> Date {
        switch self {
        case .fajr: data.fajr
        case .sunrise: data.sunrise
        case .dhuhr: data.dhuhr
        case .asr: data.asr
        case .maghrib: data.maghrib
        case .ishaa: data.ishaa
        }
    }
}
