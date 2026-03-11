//
//  DayInfo.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/03/2026.
//

import Foundation
import MiqatKit

struct DayInfo: Equatable, Identifiable {
    var id: String
    var imsak: Date?
    var fajr: Date
    var sunrise: Date
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var ishaa: Date

    var hijri: String
}

extension DayInfo {
    init(from miqatData: MiqatData) {
        self.id = miqatData.id
        self.imsak = miqatData.imsak
        self.fajr = miqatData.fajr
        self.sunrise = miqatData.sunrise
        self.dhuhr = miqatData.dhuhr
        self.asr = miqatData.asr
        self.maghrib = miqatData.maghrib
        self.ishaa = miqatData.ishaa

        if let localeMonthName = miqatData.hijriLocaleMonth {
            self.hijri = "\(miqatData.hijriDay) \(localeMonthName) \(miqatData.hijriYear)"
        } else {
            self.hijri = ""
        }
    }
}
