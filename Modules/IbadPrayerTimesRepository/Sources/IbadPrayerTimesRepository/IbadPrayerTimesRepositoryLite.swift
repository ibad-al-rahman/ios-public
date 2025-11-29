//
//  IbadPrayerTimesRepositoryLite.swift
//  IbadPrayerTimesRepository
//
//  Created by Hamza Jadid on 29/11/2025.
//

import Dependencies
import DependenciesMacros
import Foundation

public enum DayOffset: Sendable {
    case today
    case tomorrow
}

@DependencyClient
public struct IbadPrayerTimesRepositoryLite: Sendable {
    public var getPrayerTimes: @Sendable (_ dayOffset: DayOffset) async throws -> DayPrayerTimes?
    public var getWeekPrayerTimes: @Sendable () async throws -> WeekPrayerTimes?
    public var getNextPrayerTime: @Sendable () async throws -> Date?
}

extension IbadPrayerTimesRepositoryLite: DependencyKey {
    public static var liveValue: IbadPrayerTimesRepositoryLite {
        @Dependency(\.ibadPrayerTimesRepository) var repository

        return IbadPrayerTimesRepositoryLite(
            getPrayerTimes: { dayOffset in
                let calendar = Calendar.current
                let today = Date()

                let targetDate: Date
                switch dayOffset {
                case .today:
                    targetDate = today
                case .tomorrow:
                    targetDate = calendar.date(byAdding: .day, value: 1, to: today) ?? today
                }

                let year = calendar.component(.year, from: targetDate)
                let month = calendar.component(.month, from: targetDate)
                let day = calendar.component(.day, from: targetDate)

                return try await repository.getDayPrayerTimes(year, month, day)
            },
            getWeekPrayerTimes: {
                let today = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: today)
                let month = calendar.component(.month, from: today)
                let day = calendar.component(.day, from: today)

                return try await repository.getWeekPrayerTimes(year, month, day)
            }
        )
    }
}

extension IbadPrayerTimesRepositoryLite: TestDependencyKey {
    public static var previewValue: IbadPrayerTimesRepositoryLite {
        IbadPrayerTimesRepositoryLite(
            getPrayerTimes: { _ in nil },
            getWeekPrayerTimes: { nil }
        )
    }

    public static var testValue: IbadPrayerTimesRepositoryLite {
        IbadPrayerTimesRepositoryLite()
    }
}

public extension DependencyValues {
    var ibadPrayerTimesRepositoryLite: IbadPrayerTimesRepositoryLite {
        get { self[IbadPrayerTimesRepositoryLite.self] }
        set { self[IbadPrayerTimesRepositoryLite.self] = newValue }
    }
}
