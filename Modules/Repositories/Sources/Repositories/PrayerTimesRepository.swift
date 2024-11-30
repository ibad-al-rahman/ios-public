//
//  PrayerTimesRepository.swift
//  Repositories
//
//  Created by Hamza Jadid on 01/12/2024.
//

import Dependencies
import Foundation

public struct PrayerTimesRepository: Sendable {
    public var getDailyPrayerTimes: @Sendable (
        _ year: String, _ month: String, _ day: String
    ) async throws -> DailyPrayerTimesResponse
}

extension PrayerTimesRepository: DependencyKey {
    public static let liveValue: PrayerTimesRepository = {
        PrayerTimesRepository(
            getDailyPrayerTimes: { year, month, day in
                guard let url = URL(
                    string: "https://ibad-al-rahman.github.io/prayer-times/v1/day/\(year)/\(month)/\(day).json"
                ) else {
                    fatalError()
                }

                let (data, _) = try await URLSession.shared.data(from: url)
                let result = try JSONDecoder().decode(DailyPrayerTimesResponse.self, from: data)
                return result
            }
        )
    }()
}

public extension DependencyValues {
    var prayerTimesRepository: PrayerTimesRepository {
        get { self[PrayerTimesRepository.self] }
        set { self[PrayerTimesRepository.self] = newValue }
    }
}
