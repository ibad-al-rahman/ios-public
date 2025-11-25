//
//  Domain.swift
//  IbadPrayerTimesRepository
//
//  Created by Hamza Jadid on 16/01/2025.
//

import Foundation

public struct DayPrayerTimes: Sendable, Equatable {
    public let id: Int
    public let weekId: Int
    public let gregorian: String
    public let hijri: String
    public let prayerTimes: PrayerTimes
    public let event: DayEvent?

    public init(
        id: Int,
        weekId: Int,
        gregorian: String,
        hijri: String,
        prayerTimes: PrayerTimes,
        event: DayEvent?
    ) {
        self.id = id
        self.weekId = weekId
        self.gregorian = gregorian
        self.hijri = hijri
        self.prayerTimes = prayerTimes
        self.event = event
    }
}

public struct WeekPrayerTimes: Sendable, Equatable {
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

    public struct DayPrayertimes: Sendable, Equatable {
        public let id: Int
        public let gregorian: String
        public let hijri: String
        public let prayerTimes: PrayerTimes

        public init(
            id: Int,
            gregorian: String,
            hijri: String,
            prayerTimes: PrayerTimes
        ) {
            self.id = id
            self.gregorian = gregorian
            self.hijri = hijri
            self.prayerTimes = prayerTimes
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

public struct PrayerTimes: Sendable, Equatable {
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let ishaa: String

    public init(
        fajr: String,
        sunrise: String,
        dhuhr: String,
        asr: String,
        maghrib: String,
        ishaa: String
    ) {
        self.fajr = fajr
        self.sunrise = sunrise
        self.dhuhr = dhuhr
        self.asr = asr
        self.maghrib = maghrib
        self.ishaa = ishaa
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
    public var toDomain: DayPrayerTimes {
        DayPrayerTimes(
            id: id,
            weekId: weekId,
            gregorian: gregorian,
            hijri: hijri,
            prayerTimes: prayerTimes.toDomain,
            event: event?.toDomain
        )
    }
}

extension YearWeekPrayerTimesEntity.WeekPrayerTimesEntity {
    public var toDomain: WeekPrayerTimes {
        WeekPrayerTimes(
            id: id,
            mon: mon?.toDomain,
            tue: tue?.toDomain,
            wed: wed?.toDomain,
            thu: thu?.toDomain,
            fri: fri?.toDomain,
            sat: sat?.toDomain,
            sun: sun?.toDomain,
            hadith: hadith?.toDomain
        )
    }
}

extension YearWeekPrayerTimesEntity.DayPrayertimesEntity {
    public var toDomain: WeekPrayerTimes.DayPrayertimes {
        WeekPrayerTimes.DayPrayertimes(
            id: id,
            gregorian: gregorian,
            hijri: hijri,
            prayerTimes: prayerTimes.toDomain
        )
    }
}

extension PrayerTimesEntity {
    public var toDomain: PrayerTimes {
        PrayerTimes(
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
