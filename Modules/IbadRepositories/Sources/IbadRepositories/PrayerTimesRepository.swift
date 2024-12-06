//
//  PrayerTimesRepository.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct PrayerTimesRepository: Sendable {
    public var getSha1: @Sendable () async -> String?
    public var getDayPrayerTimes: @Sendable (
        _ year: Int, _ month: Int, _ day: Int
    ) async -> DayPrayerTimesResponse?
}

extension PrayerTimesRepository: DependencyKey {
    public static var liveValue: PrayerTimesRepository {
        let service = PrayerTimesService()

        return PrayerTimesRepository(
            getSha1: { await service.getSha1() },
            getDayPrayerTimes: { year, month, day in
                await service.getDayPrayerTimes(year: year, month: month, day: day)
            }
        )
    }
}

extension PrayerTimesRepository: TestDependencyKey {
    public static var previewValue: PrayerTimesRepository {
        PrayerTimesRepository(
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
            }
        )
    }

    public static var testValue: PrayerTimesRepository {
        PrayerTimesRepository()
    }
}

public extension DependencyValues {
    var prayerTimesRepository: PrayerTimesRepository {
        get { self[PrayerTimesRepository.self] }
        set { self[PrayerTimesRepository.self] = newValue }
    }
}
