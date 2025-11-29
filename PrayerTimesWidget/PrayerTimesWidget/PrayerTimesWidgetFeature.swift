//
//  PrayerTimesWidgetFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import Foundation
import IbadPrayerTimesRepository

@Reducer
struct PrayerTimesWidgetFeature {
    @ObservableState
    struct State: Equatable {
        let date: Date
        let currentPrayer: Prayer
        let nextPrayer: Prayer
        let nextPrayerDate: Date
        var todaysPrayerTimes: DayPrayerTimes?
    }

    enum Action {
        case onAppear
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let components = Calendar.current.dateComponents(
                    [.year, .month, .day], from: state.date
                )
                guard let year = components.year,
                      let month = components.month,
                      let day = components.day
                else { return .none }

                @SharedReader(.localDayPrayerTimes(year: year)) var localDayPrayerTimes = .empty
                guard let prayerTimes = localDayPrayerTimes.getDayPrayerTimes(
                    year: year, month: month, day: day
                )
                else { return .none }

                state.todaysPrayerTimes = prayerTimes.toDomain
                return .none
            }
        }
    }
}
