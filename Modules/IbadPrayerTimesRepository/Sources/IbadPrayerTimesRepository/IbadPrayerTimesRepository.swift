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
import Sharing

@DependencyClient
public struct IbadPrayerTimesRepository: Sendable {
    public var clear: @Sendable () async throws -> Void
    public var getSha1: @Sendable (_ year: Int) async throws -> String
    public var fetchSha1: @Sendable (_ year: Int) async throws -> String
    public var fetchPrayerTimes: @Sendable (_ year: Int) async throws -> Void
    public var getWeekPrayerTimes: @Sendable (_ year: Int, _ month: Int, _ day: Int) async throws -> WeekPrayerTimes?
    public var getDayPrayerTimes: @Sendable (_ year: Int, _ month: Int, _ day: Int) async throws -> DayPrayerTimes?
}

extension IbadPrayerTimesRepository: DependencyKey {
    public static var liveValue: IbadPrayerTimesRepository {
        let client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )

        return IbadPrayerTimesRepository(
            clear: {
                try PrayerTimesEntityFileManager.removeDocuments()
            },
            getSha1: { year in
                @Shared(.prayerTimesSha1) var sha1Dict: PrayerTimesSha1 = [:]
                return sha1Dict.getSha1(year: year) ?? ""
            },
            fetchSha1: { year in
                let response = try await client.getYearPrayerTimesSha1(
                    path: .init(year: String(format: "%04d", year))
                )

                let sha1 = try response.ok.body.json.sha1

                @Shared(.prayerTimesSha1) var sha1Dict: PrayerTimesSha1 = [:]
                $sha1Dict.withLock { dict in
                    dict.setSha1(sha1: sha1, for: year)
                }

                return sha1
            },
            fetchPrayerTimes: { year in
                let daysResponse = try await client.getYearPrayerTimesDays(
                    path: .init(year: String(format: "%04d", year))
                )
                let daysData = try daysResponse.ok.body.json
                let daysEntity = daysData.toEntity

                @Shared(.localDayPrayerTimes(year: year)) var localDays: YearPrayerTimesEntity = .empty
                $localDays.withLock { $0 = daysEntity }

                let weeksResponse = try await client.getYearPrayerTimesWeeks(
                    path: .init(year: String(format: "%04d", year))
                )
                print("weeks: \(weeksResponse)")
                let weeksData = try weeksResponse.ok.body.json
                let weeksEntity = weeksData.toEntity

                @Shared(.localWeekPrayerTimes(year: year)) var localWeeks: YearWeekPrayerTimesEntity = .empty
                $localWeeks.withLock { $0 = weeksEntity }
            },
            getWeekPrayerTimes: { year, month, day in
                @Shared(.localDayPrayerTimes(year: year)) var localDays: YearPrayerTimesEntity = .empty
                guard let dayData = localDays.getDayPrayerTimes(year: year, month: month, day: day) else {
                    return nil
                }

                let weekId = dayData.weekId

                @Shared(.localWeekPrayerTimes(year: year)) var localWeeks: YearWeekPrayerTimesEntity = .empty
                guard let weekEntity = localWeeks.getWeekPrayerTimes(weekId: weekId) else {
                    return nil
                }
                return weekEntity.toDomain
            },
            getDayPrayerTimes: { year, month, day in
                @Shared(.localDayPrayerTimes(year: year)) var localDays: YearPrayerTimesEntity = .empty
                guard let dayEntity = localDays.getDayPrayerTimes(year: year, month: month, day: day) else {
                    return nil
                }
                return dayEntity.toDomain
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
