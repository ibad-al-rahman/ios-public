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
            },
            getNextPrayerTime: {
                let now = Date()
                let calendar = Calendar.current
                let today = now

                let year = calendar.component(.year, from: today)
                let month = calendar.component(.month, from: today)
                let day = calendar.component(.day, from: today)

                guard let todayPrayers = try await repository.getDayPrayerTimes(year, month, day) else {
                    return nil
                }

                // Get current date components to compare times
                let currentComponents = calendar.dateComponents([.hour, .minute], from: now)

                // Helper function to get time components from prayer Date
                func getTimeComponents(_ date: Date) -> DateComponents {
                    calendar.dateComponents([.hour, .minute], from: date)
                }

                // Helper function to compare if prayer time is in the future
                func isInFuture(_ prayerTime: Date) -> Bool {
                    let prayerComponents = getTimeComponents(prayerTime)

                    guard let currentHour = currentComponents.hour,
                          let currentMinute = currentComponents.minute,
                          let prayerHour = prayerComponents.hour,
                          let prayerMinute = prayerComponents.minute else {
                        return false
                    }

                    if prayerHour > currentHour {
                        return true
                    } else if prayerHour == currentHour && prayerMinute > currentMinute {
                        return true
                    }
                    return false
                }

                // Check each prayer in order
                if isInFuture(todayPrayers.fajr) {
                    return todayPrayers.fajr
                } else if isInFuture(todayPrayers.sunrise) {
                    return todayPrayers.sunrise
                } else if isInFuture(todayPrayers.dhuhr) {
                    return todayPrayers.dhuhr
                } else if isInFuture(todayPrayers.asr) {
                    return todayPrayers.asr
                } else if isInFuture(todayPrayers.maghrib) {
                    return todayPrayers.maghrib
                } else if isInFuture(todayPrayers.ishaa) {
                    return todayPrayers.ishaa
                }

                // All prayers have passed, get tomorrow's Fajr
                let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
                let tomorrowYear = calendar.component(.year, from: tomorrow)
                let tomorrowMonth = calendar.component(.month, from: tomorrow)
                let tomorrowDay = calendar.component(.day, from: tomorrow)

                guard let tomorrowPrayers = try await repository.getDayPrayerTimes(tomorrowYear, tomorrowMonth, tomorrowDay) else {
                    return nil
                }

                return tomorrowPrayers.fajr
            }
        )
    }
}

extension IbadPrayerTimesRepositoryLite: TestDependencyKey {
    public static var previewValue: IbadPrayerTimesRepositoryLite {
        IbadPrayerTimesRepositoryLite(
            getPrayerTimes: { _ in nil },
            getWeekPrayerTimes: { nil },
            getNextPrayerTime: { nil }
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
