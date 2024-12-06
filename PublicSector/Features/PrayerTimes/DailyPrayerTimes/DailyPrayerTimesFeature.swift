//
//  DailyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import IbadRepositories

@Reducer
struct DailyPrayerTimesFeature {
    @Dependency(PrayerTimesRepository.self) private var prayerTimesRepository

    @ObservableState
    struct State: Equatable {
        var date: Date = .now
        var todaysPrayerTimes: DayPrayerTimes?
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onAppear
            case onTapShare
        }

        @CasePathable
        enum ReducerAction {
            case getDayPrayerTimes(DayPrayerTimes?)
        }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return getDayPrayerTimes(date: state.date)

            case .reducer(.getDayPrayerTimes(.some(let prayerTimes))):
                state.todaysPrayerTimes = prayerTimes
                return .none

            case .binding(\.date):
                return getDayPrayerTimes(date: state.date)

            default: return .none
            }
        }
    }

    private func getDayPrayerTimes(date: Date) -> EffectOf<Self> {
        .run { send in
            let components = Calendar.current.dateComponents(
                [.year, .month, .day],
                from: date
            )
            guard let year = components.year,
                  let month = components.month,
                  let day = components.day
            else { return }
            let response = await prayerTimesRepository
                .getDayPrayerTimes(
                    year: year, month: month, day: day
                )

            guard let response else { return }
            await send(
                .reducer(.getDayPrayerTimes(DayPrayerTimes(from: response)))
            )
        }
    }
}
