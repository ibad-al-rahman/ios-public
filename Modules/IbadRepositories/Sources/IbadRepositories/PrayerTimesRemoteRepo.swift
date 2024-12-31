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
    public var getSha1: @Sendable (
        _ year: Int
    ) async -> Result<String, ServiceError> = { _ in .failure(.unknown) }
    public var getYearPrayerTimes: @Sendable (
        _ year: Int
    ) async -> Result<[DayPrayerTimesResponse], ServiceError> = {
        _ in .failure(.unknown)
    }
}

extension PrayerTimesRemoteRepo: DependencyKey {
    public static var liveValue: PrayerTimesRemoteRepo {
        let service = PrayerTimesService()

        return PrayerTimesRemoteRepo(
            getSha1: { year in await service.getSha1(year: year) },
            getYearPrayerTimes: { year in
                await service.getYearPrayerTimes(year: year)
            }
        )
    }
}

extension PrayerTimesRemoteRepo: TestDependencyKey {
    public static var previewValue: PrayerTimesRemoteRepo {
        PrayerTimesRemoteRepo(
            getSha1: { _ in .success("sha1") },
            getYearPrayerTimes: { _ in .success([]) }
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
