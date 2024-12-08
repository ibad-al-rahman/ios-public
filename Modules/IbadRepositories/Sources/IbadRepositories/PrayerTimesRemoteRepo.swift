//
//  PrayerTimesRemoteRepo.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct PrayerTimesRemoteRepo: Sendable {
    public var getSha1: @Sendable () async -> String?
    public var getDayPrayerTimes: @Sendable (
        _ year: Int, _ month: Int, _ day: Int
    ) async -> DayPrayerTimesResponse?
    public var getYearPrayerTimes: @Sendable (
        _ year: Int
    ) async -> [DayPrayerTimesResponse]?
}

extension PrayerTimesRemoteRepo: DependencyKey {
    public static var liveValue: PrayerTimesRemoteRepo {
        let service = PrayerTimesService()

        return PrayerTimesRemoteRepo(
            getSha1: { await service.getSha1() },
            getDayPrayerTimes: { year, month, day in
                await service.getDayPrayerTimes(year: year, month: month, day: day)
            },
            getYearPrayerTimes: { year in
                await service.getYearPrayerTimes(year: year)
            }
        )
    }
}

extension PrayerTimesRemoteRepo: TestDependencyKey {
    public static var previewValue: PrayerTimesRemoteRepo {
        PrayerTimesRemoteRepo(
            getSha1: { "sha1" },
            getDayPrayerTimes: { _, _, _ in
                DayPrayerTimesResponse(
                    id: 0,
                    gregorian: "01/01/2024",
                    hijri: "01/01/1445",
                    prayerTimes: PrayerTimesResponse(
                        fajer: "4:51 am",
                        sunrise: "6:28 am",
                        dhuhr: "11:29 am",
                        asr: "2:10 pm",
                        maghrib: "4:34 pm",
                        ishaa: "5:56 pm"
                    )
                )
            },
            getYearPrayerTimes: { _ in [] }
        )
    }

    public static var testValue: PrayerTimesRemoteRepo {
        PrayerTimesRemoteRepo()
    }
}

public extension DependencyValues {
    var prayerTimesRemoteRepo: PrayerTimesRemoteRepo {
        get { self[PrayerTimesRemoteRepo.self] }
        set { self[PrayerTimesRemoteRepo.self] = newValue }
    }
}
