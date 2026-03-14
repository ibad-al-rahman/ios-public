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
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .ashura: "Ashura commemoration"
        case .battleOfBadr: "The anniversary of the Battle of Badr (2 AH)"
        case .battleOfUhud: "The anniversary of the Battle of Uhud (3 AH)"
        case .battleOfMutah: "The anniversary of the Battle of Mu'tah (8 AH)"
        case .battleOfTabuk: "The anniversary of the Battle of Tabuk (9 AH)"
        case .battleOfHattin: "The anniversary of the Battle of Hattin (583 AH)"
        case .conquestOfMecca: "Anniversary of the Conquest of Mecca (8 AH)"
        case .dayOfArafah: "Standing at Arafat"
        case .eidAlAdha: "The first day of Eid al-Adha"
        case .eidAlFitr: "The first day of Eid al-Fitr"
        case .firstOfRamadan: "First of Ramadan"
        case .islamicNewYear: "The beginning of the Hijri year"
        case .israAndMiraj: "Isra and Mi'raj"
        case .laylatAlQadr: "Laylat-ul-Qadr"
        case .mawlidAlNabi: "The anniversary of the birth of the Prophet (peace be upon him)"
        case .nisfShaban: "The night of the middle of Sha'ban"
        }
    }
}
