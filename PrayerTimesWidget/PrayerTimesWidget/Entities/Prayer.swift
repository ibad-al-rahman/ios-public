//
//  Prayer.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import SwiftUI

enum Prayer: Equatable {
    case fajr
    case sunrise
    case dhuhr
    case asr
    case maghrib
    case ishaa

    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .fajr: "fajr"
        case .sunrise: "sunrise"
        case .dhuhr: "dhuhr"
        case .asr: "asr"
        case .maghrib: "maghrib"
        case .ishaa: "ishaa"
        }
    }

    var symbol: String {
        switch self {
        case .fajr: "moon.stars"
        case .sunrise: "sunrise"
        case .dhuhr: "sun.max"
        case .asr: "sun.min"
        case .maghrib: "sunset"
        case .ishaa: "moon"
        }
    }
}
