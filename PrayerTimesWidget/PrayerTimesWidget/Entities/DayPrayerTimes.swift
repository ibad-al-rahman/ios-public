//
//  DayPrayerTimes.swift
//  PublicSector
//
//  Created by Hamza Jadid on 25/08/2024.
//

import IbadRepositories
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
    init?(from model: DayPrayerTimesStorage) {
        let calendar = Calendar.current
        let gregorianFormatter = DateFormatter()
        let hijriFormatter = DateFormatter()
        let timeFormatter = DateFormatter()

        gregorianFormatter.dateFormat = "dd/MM/yyyy"
        // DON'T REMOVE THE LOCALE AND CALENDAR else day 30 of each month will fail
        gregorianFormatter.locale = Locale(identifier: "en_US_POSIX")
        gregorianFormatter.calendar = Calendar(identifier: .gregorian)
        hijriFormatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        hijriFormatter.dateFormat = "dd/MM/yyyy"
        // DON'T REMOVE THE LOCALE else 24-hour systems won't work
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"

        self.id = model.id

        guard let gregorian = gregorianFormatter.date(from: model.gregorian)
        else { return nil }
        self.gregorian = gregorian

        gregorianFormatter.dateFormat = "d"
        self.gregorianDay = gregorianFormatter.string(from: gregorian)

        gregorianFormatter.dateFormat = "MMMM"
        self.gregorianMonth = gregorianFormatter.string(from: gregorian)

        gregorianFormatter.dateFormat = "yyyy"
        self.gregorianYear = gregorianFormatter.string(from: gregorian)

        let gregorianComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: gregorian
        )
        guard let year = gregorianComponents.year,
              let month = gregorianComponents.month,
              let day = gregorianComponents.day
        else { return nil }

        guard let hijriDate = hijriFormatter.date(from: model.hijri)
        else { return nil }

        hijriFormatter.dateFormat = "d"
        self.hijriDay = hijriFormatter.string(from: hijriDate)

        hijriFormatter.dateFormat = "MMMM"
        self.hijriMonth = hijriFormatter.string(from: hijriDate)

        hijriFormatter.dateFormat = "yyyy"
        self.hijriYear = hijriFormatter.string(from: hijriDate)

        hijriFormatter.dateFormat = "d MMMM yyyy"
        self.hijri = hijriFormatter.string(from: hijriDate)

        guard let fajr = timeFormatter.date(from: model.prayerTimes.fajr)
        else { return nil }

        var fajrComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: fajr
        )
        fajrComponents.year = year
        fajrComponents.month = month
        fajrComponents.day = day
        let fajrDate = calendar.date(from: fajrComponents)
        guard let fajrDate else { return nil }
        self.fajr = fajrDate

        guard let sunrise = timeFormatter.date(from: model.prayerTimes.sunrise)
        else { return nil }

        var sunriseComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: sunrise
        )
        sunriseComponents.year = year
        sunriseComponents.month = month
        sunriseComponents.day = day
        let sunriseDate = calendar.date(from: sunriseComponents)
        guard let sunriseDate else { return nil }
        self.sunrise = sunriseDate

        guard let dhuhr = timeFormatter.date(from: model.prayerTimes.dhuhr)
        else { return nil }

        var dhuhrComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: dhuhr
        )
        dhuhrComponents.year = year
        dhuhrComponents.month = month
        dhuhrComponents.day = day
        let dhuhrDate = calendar.date(from: dhuhrComponents)
        guard let dhuhrDate else { return nil }
        self.dhuhr = dhuhrDate

        guard let asr = timeFormatter.date(from: model.prayerTimes.asr)
        else { return nil }

        var asrComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: asr
        )
        asrComponents.year = year
        asrComponents.month = month
        asrComponents.day = day
        let asrDate = calendar.date(from: asrComponents)
        guard let asrDate else { return nil }
        self.asr = asrDate

        guard let maghrib = timeFormatter.date(from: model.prayerTimes.maghrib)
        else { return nil }

        var maghribComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: maghrib
        )
        maghribComponents.year = year
        maghribComponents.month = month
        maghribComponents.day = day
        let maghribDate = calendar.date(from: maghribComponents)
        guard let maghribDate else { return nil }
        self.maghrib = maghribDate

        guard let ishaa = timeFormatter.date(from: model.prayerTimes.ishaa)
        else { return nil }

        var ishaaComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: ishaa
        )
        ishaaComponents.year = year
        ishaaComponents.month = month
        ishaaComponents.day = day
        let ishaaDate = calendar.date(from: ishaaComponents)
        guard let ishaaDate else { return nil }
        self.ishaa = ishaaDate
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
