//
//  PrayerTimesLocalRepo.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 08/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct PrayerTimesLocalRepo: Sendable {
    public var getDayPrayerTimes: @Sendable (
        _ year: Int, _ month: Int, _ day: Int
    ) -> DayPrayerTimesModel?
    public var createYearPrayerTimes: @Sendable (
        _ days: [DayPrayerTimesModel]
    ) -> Void
}

extension PrayerTimesLocalRepo: DependencyKey {
    public static var liveValue: PrayerTimesLocalRepo {
        let dao = PrayerTimesDao()

        return PrayerTimesLocalRepo(
            getDayPrayerTimes: { year, month, day in
                dao.readPrayerTime(year: year, month: month, day: day)
            },
            createYearPrayerTimes: { days in
                do { try dao.create(days) } catch { }
            }
        )
    }
}

extension PrayerTimesLocalRepo: TestDependencyKey {
    public static var previewValue: PrayerTimesLocalRepo {
        PrayerTimesLocalRepo(
            getDayPrayerTimes: { _, _, _ in
                DayPrayerTimesModel(
                    id: 20250102,
                    gregorian: "02/01/2025",
                    hijri: "02/01/1446",
                    prayerTimes: PrayerTimesModel(
                        fajer: "5:07 am",
                        sunrise: "6:44 am",
                        dhuhr: "11:42 am",
                        asr: "2:23 pm",
                        maghrib: "4:46 pm",
                        ishaa: "6:08 pm"
                    )
                )
            },
            createYearPrayerTimes: { _ in }
        )
    }

    public static var testValue: PrayerTimesLocalRepo {
        PrayerTimesLocalRepo()
    }
}

public extension DependencyValues {
    var prayerTimesLocalRepo: PrayerTimesLocalRepo {
        get { self[PrayerTimesLocalRepo.self] }
        set { self[PrayerTimesLocalRepo.self] = newValue }
    }
}
