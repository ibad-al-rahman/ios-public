//
//  PrayerTimesWidgetFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import Foundation
import IbadRepositories

@Reducer
struct PrayerTimesWidgetFeature {
    @Dependency(\.prayerTimesLocalRepo) private var prayerTimesLocalRepo

    @ObservableState
    struct State: Equatable {
        let date: Date
        var todaysPrayerTimes: DayPrayerTimes?
        var currentPrayerTime: Prayer?
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
                      let day = components.day,
                      let dayPrayerTimes = prayerTimesLocalRepo.getDayPrayerTimes(
                        year: year, month: month, day: day
                    )
                else { return .none }
                guard let prayerTimes = DayPrayerTimes(from: dayPrayerTimes)
                else { return .none }
                state.todaysPrayerTimes = prayerTimes
                state.currentPrayerTime = getCurrentPrayerTime(
                    date: state.date,
                    prayerTimes: prayerTimes
                )
                return .none
            }
        }
    }

    private func getCurrentPrayerTime(date: Date, prayerTimes: DayPrayerTimes) -> Prayer {
        return if date.ltTime(prayerTimes.fajer) {
            .ishaa
        } else if date.ltTime(prayerTimes.sunrise) {
            .fajer
        } else if date.ltTime(prayerTimes.dhuhr) {
            .sunrise
        } else if date.ltTime(prayerTimes.asr) {
            .dhuhr
        } else if date.ltTime(prayerTimes.maghrib) {
            .asr
        } else {
            .maghrib
        }
    }
}
