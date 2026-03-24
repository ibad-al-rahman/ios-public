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
        case .imsak: "imsak"
        case .fajr: "fajr"
        case .sunrise: "sunrise"
        case .eid: "eid"
        case .dhuhr: "dhuhr"
        case .asr: "asr"
        case .maghrib: "maghrib"
        case .ishaa: "ishaa"
        }
    }
}
