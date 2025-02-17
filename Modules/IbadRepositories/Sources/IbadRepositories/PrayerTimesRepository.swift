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
    public var getSha1: @Sendable (
        _ year: Int
    ) async -> Result<String, ServiceError> = { _ in .failure(.unknown) }
    public var getYearDayPrayerTimes: @Sendable (
        _ year: Int
    ) async -> Result<YearDayPrayerTimesRespones, ServiceError> = {
        _ in .failure(.unknown)
    }
    public var getYearWeekPrayerTimes: @Sendable (
        _ year: Int
    ) async -> Result<YearWeekPrayerTimesResponse, ServiceError> = {
        _ in .failure(.unknown)
    }
}

extension PrayerTimesRepository: DependencyKey {
    public static var liveValue: PrayerTimesRepository {
        let service = PrayerTimesService()

        return PrayerTimesRepository(
            getSha1: { year in await service.getSha1(year: year) },
            getYearDayPrayerTimes: { year in
                await service.getYearDayPrayerTimes(year: year)
            },
            getYearWeekPrayerTimes: { year in
                await service.getYearWeekPrayerTimes(year: year)
            }
        )
    }
}

extension PrayerTimesRepository: TestDependencyKey {
    public static var previewValue: PrayerTimesRepository {
        PrayerTimesRepository(
            getSha1: { _ in .success("sha1") },
            getYearDayPrayerTimes: { _ in
                .success(
                    YearDayPrayerTimesRespones(year: [], sha1: "")
                )
            },
            getYearWeekPrayerTimes: { _ in
                .success(
                    YearWeekPrayerTimesResponse(
                        sha1: "",
                        weeks: [.init(
                            id: 0,
                            mon: nil,
                            tue: nil,
                            wed: nil,
                            thu: nil,
                            fri: nil,
                            sat: nil,
                            sun: nil
                        )]
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
