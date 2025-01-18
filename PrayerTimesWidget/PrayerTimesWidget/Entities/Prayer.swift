//
//  Prayer.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import SwiftUI

enum Prayer: Equatable {
    case fajer
    case sunrise
    case dhuhr
    case asr
    case maghrib
    case ishaa

    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .fajer: "Fajer"
        case .sunrise: "Sunrise"
        case .dhuhr: "Dhuhr"
        case .asr: "Asr"
        case .maghrib: "Maghrib"
        case .ishaa: "Ishaa"
        }
    }

    var symbol: String {
        switch self {
        case .fajer: "moon.stars"
        case .sunrise: "sunrise"
        case .dhuhr: "sun.max"
        case .asr: "sun.min"
        case .maghrib: "sunset"
        case .ishaa: "moon"
        }
    }
}
