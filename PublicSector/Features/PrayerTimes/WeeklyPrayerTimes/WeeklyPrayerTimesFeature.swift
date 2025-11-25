//
//  WeeklyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import IbadPrayerTimesRepository

@Reducer
struct WeeklyPrayerTimesFeature {
    @Dependency(\.ibadPrayerTimesRepository) private var prayerTimesRepository
    @ObservableState
    struct State: Equatable {
        var sat: WeekPrayerTimes.DayPrayertimes?
        var sun: WeekPrayerTimes.DayPrayertimes?
        var mon: WeekPrayerTimes.DayPrayertimes?
        var tue: WeekPrayerTimes.DayPrayertimes?
        var wed: WeekPrayerTimes.DayPrayertimes?
        var thu: WeekPrayerTimes.DayPrayertimes?
        var fri: WeekPrayerTimes.DayPrayertimes?
        var hadith: WeekPrayerTimes.Hadith?

        var isLoading: Bool {
            sat == nil
            && sun == nil
            && mon == nil
            && tue == nil
            && wed == nil
            && thu == nil
            && fri == nil
        }

        var week: [WeekPrayerTimes.DayPrayertimes?] { [sat, sun, mon, tue, wed, thu, fri] }
        var compactedWeek: [WeekPrayerTimes.DayPrayertimes] { week.compactMap { $0 } }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

        enum ViewAction {
            case onAppear
        }

        @CasePathable
        enum ReducerAction {
            case setWeekPrayerTimes(WeekPrayerTimes)
        }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                guard let ymd = Date.now.ymd else { return .none }
                return .run { [ymd] send in
                    guard let week = try await prayerTimesRepository.getWeekPrayerTimes(
                        year: ymd.year, month: ymd.month, day: ymd.day
                    ) else { return }

                    await send(.reducer(.setWeekPrayerTimes(week)))
                }

            case .reducer(.setWeekPrayerTimes(let week)):
                state.sat = week.sat
                state.sun = week.sun
                state.mon = week.mon
                state.tue = week.tue
                state.wed = week.wed
                state.thu = week.thu
                state.fri = week.fri
                state.hadith = week.hadith
                return .none

            default:
                return .none
            }
        }
    }
}
