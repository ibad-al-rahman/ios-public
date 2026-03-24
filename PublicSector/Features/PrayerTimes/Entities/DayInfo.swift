//
//  DayInfo.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/03/2026.
//

import Foundation
import MiqatKit
import struct SwiftUI.LocalizedStringKey

struct DayInfo: Equatable, Identifiable {
    var id: String
    var imsak: Date?
    var fajr: Date
    var sunrise: Date
    var eid: Date?
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var ishaa: Date

    var hijri: String
    var gregorian: Date
    var islamicEvents: [IslamicEvent]
}

extension DayInfo {
    init(from miqatData: MiqatData) {
        self.id = miqatData.id
        self.imsak = miqatData.imsak
        self.fajr = miqatData.fajr
        self.sunrise = miqatData.sunrise
        self.eid = miqatData.eid
        self.dhuhr = miqatData.dhuhr
        self.asr = miqatData.asr
        self.maghrib = miqatData.maghrib
        self.ishaa = miqatData.ishaa
        self.hijri = miqatData.hijriDate.formatted ?? ""
        self.gregorian = miqatData.gregorian
        self.islamicEvents = miqatData.islamicEvents
    }
}

extension IslamicEvent {
    var string: String {
        switch self {
        case .ashura: String(localized: "ashura", table: "Events")
        case .battleOfBadr: String(localized: "battle_of_badr", table: "Events")
        case .islamicNewYear: String(localized: "islamic_new_year", table: "Events")
        case .mawlidAlNabi: String(localized: "mawlid_al_nabi", table: "Events")
        case .battleOfHattin: String(localized: "battle_of_hattin", table: "Events")
        case .battleOfMutah: String(localized: "battle_of_mutah", table: "Events")
        case .battleOfTabuk: String(localized: "battle_of_tabuk", table: "Events")
        case .israAndMiraj: String(localized: "isra_and_miraj", table: "Events")
        case .nisfShaban: String(localized: "nisf_shaban", table: "Events")
        case .firstOfRamadan: String(localized: "first_of_ramadan", table: "Events")
        case .conquestOfMecca: String(localized: "conquest_of_mecca", table: "Events")
        case .laylatAlQadr: String(localized: "laylat_al_qadr", table: "Events")
        case .eidAlFitr: String(localized: "eid_al_fitr", table: "Events")
        case .battleOfUhud: String(localized: "battle_of_uhud", table: "Events")
        case .dayOfArafah: String(localized: "day_of_arafah", table: "Events")
        case .eidAlAdha: String(localized: "eid_al_adha", table: "Events")
        }
    }
}
