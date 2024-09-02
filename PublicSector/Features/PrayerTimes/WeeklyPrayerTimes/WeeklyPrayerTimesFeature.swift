//
//  WeeklyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct WeeklyPrayerTimesFeature {
    @ObservableState
    struct State: Equatable {
        var week: [DayPrayerTimes] = []

        init() {
            self.week = [
                DayPrayerTimes(date: .now),
                DayPrayerTimes(date: Calendar.current.date(byAdding: .day, value: 1, to: .now)!),
                DayPrayerTimes(date: Calendar.current.date(byAdding: .day, value: 2, to: .now)!),
                DayPrayerTimes(date: Calendar.current.date(byAdding: .day, value: 3, to: .now)!),
                DayPrayerTimes(date: Calendar.current.date(byAdding: .day, value: 4, to: .now)!),
                DayPrayerTimes(date: Calendar.current.date(byAdding: .day, value: 5, to: .now)!),
                DayPrayerTimes(date: Calendar.current.date(byAdding: .day, value: 6, to: .now)!)
            ]
        }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

        enum ViewAction { }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

