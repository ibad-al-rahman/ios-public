//
//  Conversions.swift
//  IbadPrayerTimesRepository
//
//  Created by Hamza Jadid on 16/01/2025.
//

import Foundation
import IdentifiedCollections

extension Components.Schemas.YearPrayerTimesDays {
    public var toEntity: YearPrayerTimesEntity {
        YearPrayerTimesEntity(
            year: IdentifiedArray(uniqueElements: year.compactMap { $0.toDayEntity }),
            sha1: sha1
        )
    }
}

extension Components.Schemas.Day {
    public var toDayEntity: DayPrayerTimesEntity? {
        guard let prayerTimes = prayerTimes else { return nil }
        return DayPrayerTimesEntity(
            id: id,
            weekId: weekId,
            gregorian: gregorian,
            hijri: hijri,
            prayerTimes: prayerTimes.toEntity,
            event: event?.toEntity
        )
    }
}

extension Components.Schemas.YearPrayerTimesWeeks {
    public var toEntity: YearWeekPrayerTimesEntity {
        YearWeekPrayerTimesEntity(
            weeks: IdentifiedArray(uniqueElements: weeks.map { $0.toEntity })
        )
    }
}

extension Components.Schemas.Week {
    public var toEntity: YearWeekPrayerTimesEntity.WeekPrayerTimesEntity {
        YearWeekPrayerTimesEntity.WeekPrayerTimesEntity(
            id: id,
            mon: mon?.toWeekDayEntity,
            tue: tue?.toWeekDayEntity,
            wed: wed?.toWeekDayEntity,
            thu: thu?.toWeekDayEntity,
            fri: fri?.toWeekDayEntity,
            sat: sat?.toWeekDayEntity,
            sun: sun?.toWeekDayEntity,
            hadith: hadith?.toEntity
        )
    }
}

extension Components.Schemas.WeekDay {
    public var toWeekDayEntity: YearWeekPrayerTimesEntity.DayPrayertimesEntity? {
        guard let prayerTimes = prayerTimes else { return nil }
        return YearWeekPrayerTimesEntity.DayPrayertimesEntity(
            id: id,
            gregorian: gregorian,
            hijri: hijri,
            prayerTimes: prayerTimes.toEntity
        )
    }
}

extension Components.Schemas.PrayerTimes {
    public var toEntity: PrayerTimesEntity {
        PrayerTimesEntity(
            fajr: fajr,
            sunrise: sunrise,
            dhuhr: dhuhr,
            asr: asr,
            maghrib: maghrib,
            ishaa: ishaa
        )
    }
}

extension Components.Schemas.Event {
    public var toEntity: DayEventEntity {
        DayEventEntity(
            ar: ar,
            en: en
        )
    }
}

extension Components.Schemas.Hadith {
    public var toEntity: YearWeekPrayerTimesEntity.HadithEntity {
        YearWeekPrayerTimesEntity.HadithEntity(
            hadith: hadith,
            note: note
        )
    }
}
