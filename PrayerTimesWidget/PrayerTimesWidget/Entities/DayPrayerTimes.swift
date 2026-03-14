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

        self.hijriDay = data.hijriDate.day
        self.hijriMonth = data.hijriDate.localeMonth ?? "\(data.hijriDate.month)"
        self.hijriYear = data.hijriDate.year

        self.fajr = data.fajr
        self.sunrise = data.sunrise
        self.dhuhr = data.dhuhr
        self.asr = data.asr
        self.maghrib = data.maghrib
        self.ishaa = data.ishaa
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
