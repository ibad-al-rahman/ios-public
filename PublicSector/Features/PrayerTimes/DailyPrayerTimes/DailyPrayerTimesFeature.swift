//
//  DailyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import IbadAnalytics
import IbadPrayerTimesRepository
import WidgetKit

@Reducer
struct DailyPrayerTimesFeature {
    @Dependency(\.ibadPrayerTimesRepository) private var prayerTimesRepository

    @ObservableState
    struct State: Equatable {
        var date: Date = .now
        var checkedYears = Set<Int>()
        var todaysPrayerTimes: DayPrayerTimes?
        var weeklyHadith: WeekPrayerTimes.Hadith?
        var error: Error?

        var canResetDate: Bool {
            Calendar.current.isDateInToday(date) == false
        }

        var event: String? {
            todaysPrayerTimes?.displayEvent
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
            case getWeeklyHadith(WeekPrayerTimes.Hadith?)
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
                state.date = .now
                WidgetCenter.shared.reloadAllTimelines()
                return getDayPrayerTimes(state: state)

            case .view(.onTapRetry):
                state.error = nil
                return getDayPrayerTimes(state: state)

            case .reducer(.getDayPrayerTimes(.some(let prayerTimes))):
                state.todaysPrayerTimes = prayerTimes
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
            // and read from the storage
            guard state.checkedYears.contains(year) == false
            else {
                let day = try? await prayerTimesRepository.getDayPrayerTimes(
                    year: year, month: month, day: day
                )
                await send(
                    .reducer(.getDayPrayerTimes(day)),
                    animation: .default
                )
                return
            }

            @SharedReader(.prayerTimesSha1) var prayerTimesSha1 = [:]
            let yearSha1 = prayerTimesSha1.getSha1(year: year)
            let responseSha = await Result { try await prayerTimesRepository.fetchSha1(year: year) }

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

            let persistanceResult = await Result {
                try await persistPrayerTimes(year: year)
            }

            @SharedReader(.localDayPrayerTimes(year: year)) var localDayPrayerTimes = .empty
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

            guard let dayPrayerTimes = try? await prayerTimesRepository.getDayPrayerTimes(
                year: year, month: month, day: day
            ) else { return }

            await send(
                .reducer(.getDayPrayerTimes(dayPrayerTimes)),
                animation: .default
            )

            guard let week = try? await prayerTimesRepository.getWeekPrayerTimes(
                year: year, month: month, day: day
            ) else { return }

            await send(
                .reducer(.getWeeklyHadith(week.hadith)),
                animation: .default
            )
        }
    }

    private func persistPrayerTimes(year: Int) async throws {
        try await prayerTimesRepository.fetchPrayerTimes(year: year)
    }
}

// MARK: - Domain Extensions
extension DayPrayerTimes {
    var shareableText: String {
        """
        \(String(localized: "Annual Prayer Times by Ibad"))
        \(hijri)
        \(gregorian.stringDate)

        🌌 \(String(localized: "Fajr")): \(fajr.time) 🌌

        🌄 \(String(localized: "Sunrise")): \(sunrise.time) 🌄

        ☀️ \(String(localized: "Dhuhr")): \(dhuhr.time) ☀️

        🌆 \(String(localized: "Asr")): \(asr.time) 🌆

        🌅 \(String(localized: "Maghrib")): \(maghrib.time) 🌅

        🌃 \(String(localized: "Ishaa")): \(ishaa.time) 🌃

        \(String(localized: "Download app"))
        \(String(localized: "Android")): https://play.google.com/store/apps/details?id=org.ibadalrahman.publicsector
        \(String(localized: "iOS")): https://apps.apple.com/lb/app/ibad-al-rahman/id6739705601
        """
    }

    var displayEvent: String? {
        guard let event = event else { return nil }
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

    static func placeholder() -> DayPrayerTimes {
        DayPrayerTimes(
            id: 0,
            weekId: 0,
            gregorian: .now,
            hijri: "1/1/1444",
            gregorianYmd: YMD(year: "2025", month: "January", day: "1"),
            hijriYmd: YMD(year: "1", month: "Muharram", day: "1444"),
            fajr: .now,
            sunrise: .now,
            dhuhr: .now,
            asr: .now,
            maghrib: .now,
            ishaa: .now,
            event: nil
        )
    }
}
