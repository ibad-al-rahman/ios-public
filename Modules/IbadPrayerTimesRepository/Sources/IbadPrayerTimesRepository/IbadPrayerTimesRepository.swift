//
//  IbadPrayerTimesRepository.swift
//  IbadPrayerTimesRepository
//
//  Created by Hamza Jadid on 16/01/2025.
//

import Dependencies
import DependenciesMacros
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

@DependencyClient
public struct IbadPrayerTimesRepository: Sendable {
    public var clear: @Sendable () async throws -> Void
    public var getSha1: @Sendable (_ year: Int) async throws -> String
    public var fetchSha1: @Sendable (_ year: Int) async throws -> String
    public var fetchPrayerTimes: @Sendable (_ year: Int) async throws -> Void
    public var getWeekPrayerTimes: @Sendable (_ year: Int, _ month: Int, _ day: Int) async throws -> YearWeekPrayerTimesEntity.WeekPrayerTimesEntity?
    public var getDayPrayerTimes: @Sendable (_ year: Int, _ month: Int, _ day: Int) async throws -> DayPrayerTimesEntity?
}

extension IbadPrayerTimesRepository: DependencyKey {
    public static var liveValue: IbadPrayerTimesRepository {
        IbadPrayerTimesRepository(
            clear: {
                // TODO: Implement clear
            },
            getSha1: { year in
                // TODO: Implement getSha1
                return ""
            },
            fetchSha1: { year in
                // TODO: Implement fetchSha1
                return ""
            },
            fetchPrayerTimes: { year in
                // TODO: Implement fetchPrayerTimes
            },
            getWeekPrayerTimes: { year, month, day in
                // TODO: Implement getWeekPrayerTimes
                return nil
            },
            getDayPrayerTimes: { year, month, day in
                // TODO: Implement getDayPrayerTimes
                return nil
            }
        )
    }
}

extension IbadPrayerTimesRepository: TestDependencyKey {
    public static var previewValue: IbadPrayerTimesRepository {
        IbadPrayerTimesRepository(
            clear: {},
            getSha1: { _ in "preview-sha1" },
            fetchSha1: { _ in "preview-sha1" },
            fetchPrayerTimes: { _ in },
            getWeekPrayerTimes: { _, _, _ in nil },
            getDayPrayerTimes: { _, _, _ in nil }
        )
    }

    public static var testValue: IbadPrayerTimesRepository {
        IbadPrayerTimesRepository()
    }
}

public extension DependencyValues {
    var ibadPrayerTimesRepository: IbadPrayerTimesRepository {
        get { self[IbadPrayerTimesRepository.self] }
        set { self[IbadPrayerTimesRepository.self] = newValue }
    }
}
