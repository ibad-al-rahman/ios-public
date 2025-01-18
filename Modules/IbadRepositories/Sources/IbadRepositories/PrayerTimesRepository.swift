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
    public var getYearPrayerTimes: @Sendable (
        _ year: Int
    ) async -> Result<[DayPrayerTimesResponse], ServiceError> = {
        _ in .failure(.unknown)
    }
}

extension PrayerTimesRepository: DependencyKey {
    public static var liveValue: PrayerTimesRepository {
        let service = PrayerTimesService()

        return PrayerTimesRepository(
            getSha1: { year in await service.getSha1(year: year) },
            getYearPrayerTimes: { year in
                await service.getYearPrayerTimes(year: year)
            }
        )
    }
}

extension PrayerTimesRepository: TestDependencyKey {
    public static var previewValue: PrayerTimesRepository {
        PrayerTimesRepository(
            getSha1: { _ in .success("sha1") },
            getYearPrayerTimes: { _ in .success([]) }
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
