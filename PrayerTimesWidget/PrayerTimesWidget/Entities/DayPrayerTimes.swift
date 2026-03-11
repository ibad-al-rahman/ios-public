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

    let hijriDay: Int
    let hijriMonth: String
    let hijriYear: Int

    var fajr: Date
    var sunrise: Date
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var ishaa: Date

    var sorted: [Date] {
        [fajr, sunrise, dhuhr, asr, maghrib, ishaa]
    }

    func getPrayer(time: Date) -> Prayer {
        return if time < fajr {
            .ishaa
        } else if time < sunrise {
            .fajr
        } else if time < dhuhr {
            .sunrise
        } else if time < asr {
            .dhuhr
        } else if time < maghrib {
            .asr
        } else if time < ishaa {
            .maghrib
        } else {
            .ishaa
        }
    }

    func getNextPrayer(time: Date) -> Prayer {
        return if time < fajr {
            .fajr
        } else if time < sunrise {
            .sunrise
        } else if time < dhuhr {
            .dhuhr
        } else if time < asr {
            .asr
        } else if time < maghrib {
            .maghrib
        } else if time < ishaa {
            .ishaa
        } else {
            .fajr
        }
    }

    func getNextPrayerTime(
        time: Date,
        tomorrowPrayerTimes: DayPrayerTimes
    ) -> Date {
        return if time < fajr {
            fajr
        } else if time < sunrise {
            sunrise
        } else if time < dhuhr {
            dhuhr
        } else if time < asr {
            asr
        } else if time < maghrib {
            maghrib
        } else if time < ishaa {
            ishaa
        } else {
            tomorrowPrayerTimes.fajr
        }
    }
}

extension DayPrayerTimes {
    init(from model: MiqatData) {
        self.id = model.id

        self.gregorian = model.gregorian

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d"
        self.gregorianDay = dateFormatter.string(from: model.gregorian)

        dateFormatter.dateFormat = "MMMM"
        self.gregorianMonth = dateFormatter.string(from: model.gregorian)

        dateFormatter.dateFormat = "yyyy"
        self.gregorianYear = dateFormatter.string(from: model.gregorian)

        self.hijriDay = model.hijriDay
        self.hijriMonth = model.hijriLocaleMonth ?? "\(model.hijriMonth)"
        self.hijriYear = model.hijriYear

        self.fajr = model.fajr
        self.sunrise = model.sunrise
        self.dhuhr = model.dhuhr
        self.asr = model.asr
        self.maghrib = model.maghrib
        self.ishaa = model.ishaa
    }

    static func placeholder() -> DayPrayerTimes {
        DayPrayerTimes(
            id: "20260101",
            gregorian: .now,
            gregorianDay: "1",
            gregorianMonth: "January",
            gregorianYear: "2026",
            hijriDay: 1,
            hijriMonth: "Muharram",
            hijriYear: 1444,
            fajr: .now,
            sunrise: .now,
            dhuhr: .now,
            asr: .now,
            maghrib: .now,
            ishaa: .now
        )
    }
}
