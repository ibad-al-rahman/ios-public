//
//  PrayerTimesRepository.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Dependencies

public struct PrayerTimesRepository: Sendable {
    var getDayPrayerTimes: @Sendable (
        _ year: Int, _ month: Int, _ day: Int
    ) async -> DayPrayerTimesResponse?
}

extension PrayerTimesRepository: DependencyKey {
    public static var liveValue: PrayerTimesRepository {
        let service = PrayerTimesService()

        return PrayerTimesRepository(
            getDayPrayerTimes: { year, month, day in
                await service.getDayPrayerTimes(year: year, month: month, day: day)
            }
        )
    }
}
