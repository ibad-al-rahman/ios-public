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
    let weekId: Int
    let gregorian: Date
    let hijri: String
    var imsak: Date?
    var fajr: Date
    var sunrise: Date
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var ishaa: Date
    var event: DayEvent?

    mutating func offset(_ offset: PrayerTimesOffset) {
        let calendar = Calendar.current
        self.fajr = calendar.date(
            byAdding: .minute, value: offset.fajr, to: fajr
        )!

        self.sunrise = calendar.date(
            byAdding: .minute, value: offset.sunrise, to: sunrise
        )!

        self.dhuhr = calendar.date(
            byAdding: .minute, value: offset.dhuhr, to: dhuhr
        )!

        self.asr = calendar.date(
            byAdding: .minute, value: offset.asr, to: asr
        )!

        self.maghrib = calendar.date(
            byAdding: .minute, value: offset.maghrib, to: maghrib
        )!

        self.ishaa = calendar.date(
            byAdding: .minute, value: offset.ishaa, to: ishaa
        )!
    }

    var shareableText: String {
        """
        \(String(localized: "Annual Prayer Times by Ibad"))
        \(hijri)
        \(gregorian.stringDate)

        🌌 \(String(localized: "Fajr")): \(fajr.time) 🌌

        🌄 \(String(localized: "Sunrise")): \(sunrise.time) 🌄

        ☀️ \(String(localized: "Dhuhr")): \(dhuhr.time) ☀️

        🌆 \(String(localized: "Asr")): \(asr.time) 🌆

        🌅 \(String(localized: "Maghrib")): \(maghrib.time) 🌅

        🌃 \(String(localized: "Ishaa")): \(ishaa.time) 🌃

        \(String(localized: "Download app"))
        \(String(localized: "Android")): https://play.google.com/store/apps/details?id=org.ibadalrahman.publicsector
        \(String(localized: "iOS")): https://apps.apple.com/lb/app/ibad-al-rahman/id6739705601
        """
    }
}

extension DayPrayerTimes {
    init?(from storage: DayPrayerTimesStorage) {
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

        self.id = storage.id
        self.weekId = storage.weekId

        guard let gregorian = gregorianFormatter.date(from: storage.gregorian)
        else { return nil }
        self.gregorian = gregorian

        guard let hijriDate = hijriFormatter.date(from: storage.hijri)
        else { return nil }
        hijriFormatter.dateFormat = "d MMMM yyyy"
        let hijri = hijriFormatter.string(from: hijriDate)
        self.hijri = hijri

        self.imsak = storage.prayerTimes.imsak.flatMap { timeFormatter.date(from: $0) }

        guard let fajr = timeFormatter.date(from: storage.prayerTimes.fajr)
        else { return nil }
        self.fajr = fajr

        guard let sunrise = timeFormatter.date(from: storage.prayerTimes.sunrise)
        else { return nil }
        self.sunrise = sunrise

        guard let dhuhr = timeFormatter.date(from: storage.prayerTimes.dhuhr)
        else { return nil }
        self.dhuhr = dhuhr

        guard let asr = timeFormatter.date(from: storage.prayerTimes.asr)
        else { return nil }
        self.asr = asr

        guard let maghrib = timeFormatter.date(from: storage.prayerTimes.maghrib)
        else { return nil }
        self.maghrib = maghrib

        guard let ishaa = timeFormatter.date(from: storage.prayerTimes.ishaa)
        else { return nil }
        self.ishaa = ishaa

        self.event = DayEvent(from: storage)
    }

    init?(
        from storage: YearWeekPrayerTimesStorage.DayPrayertimesStorage?,
        weekId: Int
    ) {
        guard let storage else { return nil }

        let gregorianFormatter = DateFormatter()
        let hijriFormatter = DateFormatter()
        let timeFormatter = DateFormatter()

        gregorianFormatter.dateFormat = "dd/MM/yyyy"
        hijriFormatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        hijriFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"

        self.id = storage.id
        self.weekId = weekId

        guard let gregorian = gregorianFormatter.date(from: storage.gregorian)
        else { return nil }
        self.gregorian = gregorian

        guard let hijriDate = hijriFormatter.date(from: storage.hijri)
        else { return nil }
        hijriFormatter.dateFormat = "d MMMM yyyy"
        let hijri = hijriFormatter.string(from: hijriDate)
        self.hijri = hijri

        guard let fajr = timeFormatter.date(from: storage.prayerTimes.fajr)
        else { return nil }
        self.fajr = fajr

        guard let sunrise = timeFormatter.date(from: storage.prayerTimes.sunrise)
        else { return nil }
        self.sunrise = sunrise

        guard let dhuhr = timeFormatter.date(from: storage.prayerTimes.dhuhr)
        else { return nil }
        self.dhuhr = dhuhr

        guard let asr = timeFormatter.date(from: storage.prayerTimes.asr)
        else { return nil }
        self.asr = asr

        guard let maghrib = timeFormatter.date(from: storage.prayerTimes.maghrib)
        else { return nil }
        self.maghrib = maghrib

        guard let ishaa = timeFormatter.date(from: storage.prayerTimes.ishaa)
        else { return nil }
        self.ishaa = ishaa
    }

    static func placeholder() -> DayPrayerTimes {
        DayPrayerTimes(
            id: 0,
            weekId: 0,
            gregorian: .now,
            hijri: "1/1/1444",
            fajr: .now,
            sunrise: .now,
            dhuhr: .now,
            asr: .now,
            maghrib: .now,
            ishaa: .now
        )
    }
}
