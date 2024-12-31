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
        @Shared(.prayerTimesSha1) var prayerTimesSha1 = [:]
        var date: Date = .now
        var todaysPrayerTimes: DayPrayerTimes?
        var canResetDate: Bool {
            Calendar.current.isDateInToday(date) == false
        }
        var event: String? {
            guard let event = todaysPrayerTimes?.event else { return nil }
            return if event.en != nil {
                switch Locale.current.language.languageCode?.identifier {
                case "en": event.en
                case "ar": event.ar
                default: nil
                }
            } else {
                event.ar
            }
        }
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
            case setSha1(sha1: String, year: Int)
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
                return .concatenate(
                    fillYearData(date: state.date, sha1: state.prayerTimesSha1),
                    getDayPrayerTimes(date: state.date)
                )

            case .reducer(.getDayPrayerTimes(.some(let prayerTimes))):
                state.todaysPrayerTimes = prayerTimes
                return .none

            case let .reducer(.setSha1(sha1, year)):
                state.prayerTimesSha1.setSha1(sha1: sha1, for: year)
                return .none

            case .binding(\.date):
                return .concatenate(
                    fillYearData(date: state.date, sha1: state.prayerTimesSha1),
                    getDayPrayerTimes(date: state.date)
                )

            default: return .none
            }
        }
    }

    private func fillYearData(date: Date, sha1: PrayerTimesSha1) -> EffectOf<Self> {
        .run { send in
            let components = Calendar.current.dateComponents(
                [.year, .month, .day], from: date
            )
            guard let year = components.year
            else { return }

            let yearSha1 = sha1.getSha1(year: year)

            let responseSha = await prayerTimesRemoteRepo.getSha1(year: year)
            if let responseSha, yearSha1 != responseSha {
                await send(.reducer(.setSha1(sha1: responseSha, year: year)))

                guard let daysOfYear = await prayerTimesRemoteRepo
                    .getYearPrayerTimes(year: year)
                else { return }
                prayerTimesLocalRepo.createYearPrayerTimes(
                    daysOfYear.map { $0.intoModel }
                )
            }
        }
    }

    private func getDayPrayerTimes(date: Date) -> EffectOf<Self> {
        .run { send in
            let components = Calendar.current.dateComponents(
                [.year, .month, .day], from: date
            )
            guard let year = components.year,
                  let month = components.month,
                  let day = components.day
            else { return }

            guard let day = prayerTimesLocalRepo.getDayPrayerTimes(
                year: year, month: month, day: day
            ) else { return }
            await send(.reducer(.getDayPrayerTimes(DayPrayerTimes(from: day))))
        }
    }
}
