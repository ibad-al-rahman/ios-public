//
//  Prayer.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import SwiftUI

enum Prayer: Equatable {
    case imsak
    case fajr
    case sunrise
    case eid
    case dhuhr
    case asr
    case maghrib
    case ishaa

    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .imsak: "Imsak"
        case .fajr: "Fajr"
        case .sunrise: "Sunrise"
        case .eid: "Eid"
        case .dhuhr: "Dhuhr"
        case .asr: "Asr"
        case .maghrib: "Maghrib"
        case .ishaa: "Ishaa"
        }
    }
}
