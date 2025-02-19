//
//  WeeklyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import IbadRepositories

@Reducer
struct WeeklyPrayerTimesFeature {
    @ObservableState
    struct State: Equatable {
        var sat: DayPrayerTimes?
        var sun: DayPrayerTimes?
        var mon: DayPrayerTimes?
        var tue: DayPrayerTimes?
        var wed: DayPrayerTimes?
        var thu: DayPrayerTimes?
        var fri: DayPrayerTimes?

        var isLoading: Bool {
            sat == nil
            && sun == nil
            && mon == nil
            && tue == nil
            && wed == nil
            && thu == nil
            && fri == nil
        }

        var week: [DayPrayerTimes?] { [sat, sun, mon, tue, wed, thu, fri] }
        var compactedWeek: [DayPrayerTimes] { week.compactMap { $0 } }
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
            case setWeekPrayerTimes(
                YearWeekPrayerTimesStorage.WeekPrayerTimesStorage
            )
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
                    @SharedReader(
                        .localDayPrayerTimes(year: ymd.year)
                    ) var localDayPrayerTimes = .empty
                    @SharedReader(
                        .localWeekPrayerTimes(year: ymd.year)
                    ) var localWeekPrayerTimes = .empty

                    guard let day = localDayPrayerTimes.getDayPrayerTimes(
                        year: ymd.year, month: ymd.month, day: ymd.day
                    ) else { return }

                    guard let week = localWeekPrayerTimes.getWeekPrayerTimes(
                        weekId: day.weekId
                    )
                    else { return }

                    await send(.reducer(.setWeekPrayerTimes(week)))
                }

            case .reducer(.setWeekPrayerTimes(let week)):
                state.sat = DayPrayerTimes(from: week.sat, weekId: 0)
                state.sun = DayPrayerTimes(from: week.sun, weekId: 0)
                state.mon = DayPrayerTimes(from: week.mon, weekId: 0)
                state.tue = DayPrayerTimes(from: week.tue, weekId: 0)
                state.wed = DayPrayerTimes(from: week.wed, weekId: 0)
                state.thu = DayPrayerTimes(from: week.thu, weekId: 0)
                state.fri = DayPrayerTimes(from: week.fri, weekId: 0)
                return .none

            default:
                return .none
            }
        }
    }
}
