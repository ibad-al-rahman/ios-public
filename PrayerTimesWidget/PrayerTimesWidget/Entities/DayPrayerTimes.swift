//
//  DayPrayerTimes.swift
//  PublicSector
//
//  Created by Hamza Jadid on 25/08/2024.
//

import MiqatKit
import Foundation

struct DayPrayerTimes: Equatable, Identifiable {
    let id: String

    let gregorian: Date

    let gregorianDay: String
    let gregorianMonth: String
    let gregorianYear: String

    let hijriDay: String
    let hijriMonth: String
    let hijriYear: String

    var fajr: Date
    var sunrise: Date
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var ishaa: Date

    var sorted: [Date] {
        [fajr, sunrise, dhuhr, asr, maghrib, ishaa]
    }
}

extension DayPrayerTimes {
    init(from data: MiqatData) {
        self.id = data.id

        self.gregorian = data.gregorian

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d"
        self.gregorianDay = dateFormatter.string(from: data.gregorian)

        dateFormatter.dateFormat = "MMMM"
        self.gregorianMonth = dateFormatter.string(from: data.gregorian)

        dateFormatter.dateFormat = "yyyy"
        self.gregorianYear = dateFormatter.string(from: data.gregorian)

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none

        self.hijriDay = numberFormatter.string(from: NSNumber(value: data.hijriDate.day)) ?? "\(data.hijriDate.day)"
        self.hijriMonth = data.hijriDate.localeMonth ?? "\(data.hijriDate.month)"
        self.hijriYear = numberFormatter.string(from: NSNumber(value: data.hijriDate.year)) ?? "\(data.hijriDate.year)"

        self.fajr = data.fajr
        self.sunrise = data.sunrise
        self.dhuhr = data.dhuhr
        self.asr = data.asr
        self.maghrib = data.maghrib
        self.ishaa = data.ishaa
    }
}
