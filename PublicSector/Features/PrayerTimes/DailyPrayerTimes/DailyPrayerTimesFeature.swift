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
    @Dependency(\.prayerTimesLocalRepo) private var prayerTimesLocalRepo
    @Dependency(\.prayerTimesRemoteRepo) private var prayerTimesRemoteRepo

    @ObservableState
    struct State: Equatable {
        @Shared(.sha1) var sha1 = nil
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
            case setSha1(String)
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
                return getDayPrayerTimes(state: state)

            case .reducer(.getDayPrayerTimes(.some(let prayerTimes))):
                state.todaysPrayerTimes = prayerTimes
                return .none

            case .binding(\.date):
                return getDayPrayerTimes(state: state)

            default: return .none
            }
        }
    }

    private func getDayPrayerTimes(state: State) -> EffectOf<Self> {
        .run { send in
            let sha1 = await prayerTimesRemoteRepo.getSha1()
            if let sha1, sha1 != state.sha1 {
                await send(.reducer(.setSha1(sha1)))
            }
            let components = Calendar.current.dateComponents(
                [.year, .month, .day], from: state.date
            )
            guard let year = components.year,
                  let month = components.month,
                  let day = components.day
            else { return }
            guard let daysOfYear = await prayerTimesRemoteRepo.getYearPrayerTimes(
                year: year
            ) else { return }
            prayerTimesLocalRepo.createYearPrayerTimes(daysOfYear.map { $0.intoModel })
            guard let day = prayerTimesLocalRepo.getDayPrayerTimes(
                year: year, month: month, day: day
            ) else { return }
            await send(.reducer(.getDayPrayerTimes(DayPrayerTimes(from: day))))
        }
    }
}
