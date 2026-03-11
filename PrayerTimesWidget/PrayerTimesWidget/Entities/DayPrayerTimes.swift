//
//  DayPrayerTimes.swift
//  PublicSector
//
//  Created by Hamza Jadid on 25/08/2024.
//

import MiqatKit
import Foundation

struct DayPrayerTimes: Equatable, Identifiable {
    let id: Int
    let gregorian: Date
    let hijri: String
    let hijriDay: String
    let hijriMonth: String
    let hijriYear: String
    let gregorianDay: String
    let gregorianMonth: String
    let gregorianYear: String
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
        let gregorianFormatter = DateFormatter()
        gregorianFormatter.locale = Locale(identifier: "en_US_POSIX")
        gregorianFormatter.calendar = Calendar(identifier: .gregorian)
        gregorianFormatter.dateFormat = "yyyyMMdd"

        let gregorian = gregorianFormatter.date(from: model.id) ?? model.fajr
        self.gregorian = gregorian
        self.id = Int(model.id) ?? 0

        gregorianFormatter.dateFormat = "d"
        self.gregorianDay = gregorianFormatter.string(from: gregorian)

        gregorianFormatter.dateFormat = "MMMM"
        self.gregorianMonth = gregorianFormatter.string(from: gregorian)

        gregorianFormatter.dateFormat = "yyyy"
        self.gregorianYear = gregorianFormatter.string(from: gregorian)

        self.hijriDay = "\(model.hijriDay)"
        self.hijriYear = "\(model.hijriYear)"

        if let localeMonth = model.hijriLocaleMonth {
            self.hijriMonth = localeMonth
            self.hijri = "\(model.hijriDay) \(localeMonth) \(model.hijriYear)"
        } else {
            self.hijriMonth = "\(model.hijriMonth)"
            self.hijri = "\(model.hijriDay)/\(model.hijriMonth)/\(model.hijriYear)"
        }

        self.fajr = model.fajr
        self.sunrise = model.sunrise
        self.dhuhr = model.dhuhr
        self.asr = model.asr
        self.maghrib = model.maghrib
        self.ishaa = model.ishaa
    }

    static func placeholder() -> DayPrayerTimes {
        DayPrayerTimes(
            id: 0,
            gregorian: .now,
            hijri: "1",
            hijriDay: "January",
            hijriMonth: "2024",
            hijriYear: "1/1/1444",
            gregorianDay: "1",
            gregorianMonth: "Muharram",
            gregorianYear: "1444",
            fajr: .now,
            sunrise: .now,
            dhuhr: .now,
            asr: .now,
            maghrib: .now,
            ishaa: .now
        )
    }
}
