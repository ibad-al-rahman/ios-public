//
//  DailyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import IbadAnalytics
import MiqatKit
import IbadRepositories
import WidgetKit

@Reducer
struct DailyPrayerTimesFeature {
    @Dependency(\.prayerTimesRepository) private var prayerTimesRepository
    @Dependency(\.miqatService) private var miqatService

    @ObservableState
    struct State: Equatable {
        var date: Date = .now
        var hasAppeared: Bool = false
        var checkedYears = Set<Int>()
        var todaysPrayerTimes: DayPrayerTimes?
        var weeklyHadith: Hadith?
        var error: Error?

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
            case onTapRetry
        }

        @CasePathable
        enum ReducerAction {
            case getDayPrayerTimes(DayPrayerTimes?)
            case getWeeklyHadith(Hadith?)
            case appendCheckedYear(year: Int)
            case setError(Error)
        }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    enum Error: Swift.Error {
        case unreachable
        case unknown
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        AnalyticsReducer { state, action in
            switch action {
            case .view(.onAppear):
                return .screen(name: "DailyPrayerTimes")

            case .reducer(.setError(let why)):
                return .error(why)

            default:
                return .none
            }
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.error = nil
                if !state.hasAppeared {
                    state.hasAppeared = true
                    state.date = .now
                }
                WidgetCenter.shared.reloadAllTimelines()
                return getDayPrayerTimes(state: state)

            case .view(.onTapRetry):
                state.error = nil
                return getDayPrayerTimes(state: state)

            case .reducer(.getDayPrayerTimes(.some(let prayerTimes))):
                state.todaysPrayerTimes = prayerTimes
                let tzOffset = TimeZone.current.secondsFromGMT()
                let timestamp = state.date.timeIntervalSince1970 + TimeInterval(tzOffset)
                let prayerTimes = miqatService.getPrecomputedPrayerTimes(
                    timestampSecs: timestamp, provider: .darElFatwa(.beirut)
                )
                state.todaysPrayerTimes?.fajr = prayerTimes.fajr
                state.todaysPrayerTimes?.sunrise = prayerTimes.sunrise
                state.todaysPrayerTimes?.dhuhr = prayerTimes.dhuhr
                state.todaysPrayerTimes?.asr = prayerTimes.asr
                state.todaysPrayerTimes?.maghrib = prayerTimes.maghrib
                state.todaysPrayerTimes?.ishaa = prayerTimes.ishaa
                return .none

            case .reducer(.getWeeklyHadith(let hadith)):
                state.weeklyHadith = hadith
                return .none

            case .reducer(.appendCheckedYear(let year)):
                state.checkedYears.insert(year)
                return .none

            case .reducer(.setError(let error)):
                state.error = error
                return .none

            case .binding(\.date):
                state.error = nil
                return getDayPrayerTimes(state: state)

            default: return .none
            }
        }
    }

    private func getDayPrayerTimes(state: State) -> EffectOf<Self> {
        .run { send in
            guard let ymd = state.date.ymd else { return }
            let year = ymd.year
            let month = ymd.month
            let day = ymd.day

            // if we already checked this year's sha, then skip the process
            // and ready from the storage
            guard state.checkedYears.contains(year) == false
            else {
                @SharedReader(.localDayPrayerTimes(year: year)) var localDayPrayerTimes = .empty
                guard let day = localDayPrayerTimes.getDayPrayerTimes(
                    year: year, month: month, day: day
                ) else { return }
                await send(
                    .reducer(.getDayPrayerTimes(DayPrayerTimes(from: day))),
                    animation: .default
                )
                return
            }

            @SharedReader(.prayerTimesSha1) var prayerTimesSha1 = [:]
            let yearSha1 = prayerTimesSha1.getSha1(year: year)
            let responseSha = await Result { try await prayerTimesRepository.getSha1(year: year) }

            var isDirty = false

            switch (yearSha1, responseSha) {
            case let (.some(currentSha), .success(remoteSha)):
                if currentSha == remoteSha { break }
                isDirty = true

            case (.none, .success):
                isDirty = true

            case (.some, .failure):
                break

            case (.none, .failure):
                await send(.reducer(.setError(.unknown)))
                return
            }

            @SharedReader(.localDayPrayerTimes(year: year)) var localDayPrayerTimes = .empty

            let persistanceResult = await Result {
                try await persistPrayerTimes(year: year)
            }
            if isDirty || localDayPrayerTimes.isEmpty {
                switch persistanceResult {
                case .success:
                    break

                case .failure:
                    await send(.reducer(.setError(.unknown)))
                    return
                }
                await send(.reducer(.appendCheckedYear(year: year)))
            }

            guard let day = localDayPrayerTimes.getDayPrayerTimes(
                year: year, month: month, day: day
            ) else { return }

            await send(
                .reducer(.getDayPrayerTimes(DayPrayerTimes(from: day))),
                animation: .default
            )

            @SharedReader(
                .localWeekPrayerTimes(year: ymd.year)
            ) var localWeekPrayerTimes = .empty

            guard let week = localWeekPrayerTimes.getWeekPrayerTimes(
                weekId: day.weekId
            )
            else { return }
            await send(
                .reducer(.getWeeklyHadith(Hadith(from: week.hadith))),
                animation: .default
            )
        }
    }

    private func persistPrayerTimes(year: Int) async throws {
        let weeksResponse = try await prayerTimesRepository.getYearWeekPrayerTimes(year: year)
        @Shared(
            .localWeekPrayerTimes(year: year)
        ) var localWeekPrayerTimes = .empty
        $localWeekPrayerTimes.withLock {
            $0 = YearWeekPrayerTimesStorage(
                year: IdentifiedArray(uniqueElements: weeksResponse.weeks.map { week in week.intoStorage })
            )
        }

        let daysReponse = try await prayerTimesRepository.getYearDayPrayerTimes(year: year)
        @Shared(.localDayPrayerTimes(year: year)) var localDayPrayerTimes = .empty
        @Shared(.prayerTimesSha1) var prayerTimesSha1 = [:]
        $localDayPrayerTimes.withLock {
            $0 = YearPrayerTimesStorage(
                year: IdentifiedArray(uniqueElements: daysReponse.year.map { day in day.intoStorage }),
                sha1: daysReponse.sha1
            )
        }
        $prayerTimesSha1.withLock {
            $0.setSha1(sha1: daysReponse.sha1, for: year)
        }
    }
}
