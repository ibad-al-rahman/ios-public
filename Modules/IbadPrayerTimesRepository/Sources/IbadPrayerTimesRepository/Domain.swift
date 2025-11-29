//
//  Domain.swift
//  IbadPrayerTimesRepository
//
//  Created by Hamza Jadid on 16/01/2025.
//

import Foundation

public struct YMD: Sendable, Equatable {
    public let year: String
    public let month: String
    public let day: String

    public init(year: String, month: String, day: String) {
        self.year = year
        self.month = month
        self.day = day
    }
}

public struct DayPrayerTimes: Sendable, Equatable, Identifiable {
    public let id: Int
    public let weekId: Int
    public let gregorian: Date
    public let hijri: String
    public let gregorianYmd: YMD
    public let hijriYmd: YMD
    public let fajr: Date
    public let sunrise: Date
    public let dhuhr: Date
    public let asr: Date
    public let maghrib: Date
    public let ishaa: Date
    public let event: DayEvent?

    public var fajrId: String {
        "f\(id)"
    }

    // made it "sr" because in the future we might add "suhur", so "s" will collide
    public var sunriseId: String {
        "sr\(id)"
    }

    public var dhuhrId: String {
        "d\(id)"
    }

    public var asrId: String {
        "a\(id)"
    }

    public var maghribId: String {
        "m\(id)"
    }

    public var ishaaId: String {
        "i\(id)"
    }

    public var sorted: [Date] {
        [fajr, sunrise, dhuhr, asr, maghrib, ishaa]
    }

    public init(
        id: Int,
        weekId: Int,
        gregorian: Date,
        hijri: String,
        gregorianYmd: YMD,
        hijriYmd: YMD,
        fajr: Date,
        sunrise: Date,
        dhuhr: Date,
        asr: Date,
        maghrib: Date,
        ishaa: Date,
        event: DayEvent?
    ) {
        self.id = id
        self.weekId = weekId
        self.gregorian = gregorian
        self.hijri = hijri
        self.gregorianYmd = gregorianYmd
        self.hijriYmd = hijriYmd
        self.fajr = fajr
        self.sunrise = sunrise
        self.dhuhr = dhuhr
        self.asr = asr
        self.maghrib = maghrib
        self.ishaa = ishaa
        self.event = event
    }
}

public struct WeekPrayerTimes: Sendable, Equatable, Identifiable {
    public let id: Int
    public let mon: DayPrayertimes?
    public let tue: DayPrayertimes?
    public let wed: DayPrayertimes?
    public let thu: DayPrayertimes?
    public let fri: DayPrayertimes?
    public let sat: DayPrayertimes?
    public let sun: DayPrayertimes?
    public let hadith: Hadith?

    public init(
        id: Int,
        mon: DayPrayertimes?,
        tue: DayPrayertimes?,
        wed: DayPrayertimes?,
        thu: DayPrayertimes?,
        fri: DayPrayertimes?,
        sat: DayPrayertimes?,
        sun: DayPrayertimes?,
        hadith: Hadith?
    ) {
        self.id = id
        self.mon = mon
        self.tue = tue
        self.wed = wed
        self.thu = thu
        self.fri = fri
        self.sat = sat
        self.sun = sun
        self.hadith = hadith
    }

    public struct DayPrayertimes: Sendable, Equatable, Identifiable {
        public let id: Int
        public let gregorian: Date
        public let hijri: String
        public let fajr: Date
        public let sunrise: Date
        public let dhuhr: Date
        public let asr: Date
        public let maghrib: Date
        public let ishaa: Date

        public init(
            id: Int,
            gregorian: Date,
            hijri: String,
            fajr: Date,
            sunrise: Date,
            dhuhr: Date,
            asr: Date,
            maghrib: Date,
            ishaa: Date
        ) {
            self.id = id
            self.gregorian = gregorian
            self.hijri = hijri
            self.fajr = fajr
            self.sunrise = sunrise
            self.dhuhr = dhuhr
            self.asr = asr
            self.maghrib = maghrib
            self.ishaa = ishaa
        }
    }

    public struct Hadith: Sendable, Equatable {
        public let hadith: String
        public let note: String?

        public init(hadith: String, note: String?) {
            self.hadith = hadith
            self.note = note
        }
    }
}

public struct DayEvent: Sendable, Equatable {
    public let ar: String
    public let en: String?

    public init(ar: String, en: String?) {
        self.ar = ar
        self.en = en
    }
}

// MARK: - Entity to Domain Conversions

extension DayPrayerTimesEntity {
    public var toDomain: DayPrayerTimes? {
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

        guard let gregorianDate = gregorianFormatter.date(from: gregorian) else { return nil }

        guard let hijriDate = hijriFormatter.date(from: hijri) else { return nil }
        hijriFormatter.dateFormat = "d MMMM yyyy"
        let formattedHijri = hijriFormatter.string(from: hijriDate)

        // Extract Gregorian YMD
        gregorianFormatter.dateFormat = "d"
        let gregorianDay = gregorianFormatter.string(from: gregorianDate)
        gregorianFormatter.dateFormat = "MMMM"
        let gregorianMonth = gregorianFormatter.string(from: gregorianDate)
        gregorianFormatter.dateFormat = "yyyy"
        let gregorianYear = gregorianFormatter.string(from: gregorianDate)

        // Extract Hijri YMD
        hijriFormatter.dateFormat = "d"
        let hijriDay = hijriFormatter.string(from: hijriDate)
        hijriFormatter.dateFormat = "MMMM"
        let hijriMonth = hijriFormatter.string(from: hijriDate)
        hijriFormatter.dateFormat = "yyyy"
        let hijriYear = hijriFormatter.string(from: hijriDate)

        guard let fajr = timeFormatter.date(from: prayerTimes.fajr) else { return nil }
        guard let sunrise = timeFormatter.date(from: prayerTimes.sunrise) else { return nil }
        guard let dhuhr = timeFormatter.date(from: prayerTimes.dhuhr) else { return nil }
        guard let asr = timeFormatter.date(from: prayerTimes.asr) else { return nil }
        guard let maghrib = timeFormatter.date(from: prayerTimes.maghrib) else { return nil }
        guard let ishaa = timeFormatter.date(from: prayerTimes.ishaa) else { return nil }

        return DayPrayerTimes(
            id: id,
            weekId: weekId,
            gregorian: gregorianDate,
            hijri: formattedHijri,
            gregorianYmd: YMD(year: gregorianYear, month: gregorianMonth, day: gregorianDay),
            hijriYmd: YMD(year: hijriYear, month: hijriMonth, day: hijriDay),
            fajr: fajr,
            sunrise: sunrise,
            dhuhr: dhuhr,
            asr: asr,
            maghrib: maghrib,
            ishaa: ishaa,
            event: event?.toDomain
        )
    }
}

extension YearWeekPrayerTimesEntity.WeekPrayerTimesEntity {
    public var toDomain: WeekPrayerTimes? {
        WeekPrayerTimes(
            id: id,
            mon: mon?.toDomain(weekId: id),
            tue: tue?.toDomain(weekId: id),
            wed: wed?.toDomain(weekId: id),
            thu: thu?.toDomain(weekId: id),
            fri: fri?.toDomain(weekId: id),
            sat: sat?.toDomain(weekId: id),
            sun: sun?.toDomain(weekId: id),
            hadith: hadith?.toDomain
        )
    }
}

extension YearWeekPrayerTimesEntity.DayPrayertimesEntity {
    public func toDomain(weekId: Int) -> WeekPrayerTimes.DayPrayertimes? {
        let gregorianFormatter = DateFormatter()
        let hijriFormatter = DateFormatter()
        let timeFormatter = DateFormatter()

        gregorianFormatter.dateFormat = "dd/MM/yyyy"
        gregorianFormatter.locale = Locale(identifier: "en_US_POSIX")
        gregorianFormatter.calendar = Calendar(identifier: .gregorian)
        hijriFormatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        hijriFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"

        guard let gregorianDate = gregorianFormatter.date(from: gregorian) else { return nil }

        guard let hijriDate = hijriFormatter.date(from: hijri) else { return nil }
        hijriFormatter.dateFormat = "d MMMM yyyy"
        let formattedHijri = hijriFormatter.string(from: hijriDate)

        guard let fajr = timeFormatter.date(from: prayerTimes.fajr) else { return nil }
        guard let sunrise = timeFormatter.date(from: prayerTimes.sunrise) else { return nil }
        guard let dhuhr = timeFormatter.date(from: prayerTimes.dhuhr) else { return nil }
        guard let asr = timeFormatter.date(from: prayerTimes.asr) else { return nil }
        guard let maghrib = timeFormatter.date(from: prayerTimes.maghrib) else { return nil }
        guard let ishaa = timeFormatter.date(from: prayerTimes.ishaa) else { return nil }

        return WeekPrayerTimes.DayPrayertimes(
            id: id,
            gregorian: gregorianDate,
            hijri: formattedHijri,
            fajr: fajr,
            sunrise: sunrise,
            dhuhr: dhuhr,
            asr: asr,
            maghrib: maghrib,
            ishaa: ishaa
        )
    }
}

extension DayEventEntity {
    public var toDomain: DayEvent {
        DayEvent(ar: ar, en: en)
    }
}

extension YearWeekPrayerTimesEntity.HadithEntity {
    public var toDomain: WeekPrayerTimes.Hadith {
        WeekPrayerTimes.Hadith(hadith: hadith, note: note)
    }
}
