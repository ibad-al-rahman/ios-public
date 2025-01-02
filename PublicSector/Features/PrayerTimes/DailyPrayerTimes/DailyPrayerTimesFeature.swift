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
    @Dependency(\.publicationRemoteRepo) private var publicationRemoteRepo

    @ObservableState
    struct State: Equatable {
        @Shared(.prayerTimesSha1) var prayerTimesSha1 = [:]
        var date: Date = .now
        var checkedYears = Set<Int>()
        var todaysPrayerTimes: DayPrayerTimes?
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
            case onTapShare
            case onTapRetry
        }

        @CasePathable
        enum ReducerAction {
            case setSha1(sha1: String, year: Int)
            case getDayPrayerTimes(DayPrayerTimes?)
            case appendCheckedYear(year: Int)
            case setError(Error)
        }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    enum Error {
        case unreachable
        case unknown
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
 state,
 action in
            switch action {
            case .view(.onAppear):
                state.error = nil
                return .merge(
                    getDayPrayerTimes(state: state),
                    .run { _ in
                        let res = await publicationRemoteRepo
                            .downloadPublication(
                                id: "40f3656a3597df8eab3a3ad47f2230cf",
                                to: .documentsDirectory
                                    .appending(
                                        component: "40f3656a3597df8eab3a3ad47f2230cf"
                                    )
                            )
                        print(res)
                    }
                )

            case .view(.onTapRetry):
                state.error = nil
                return getDayPrayerTimes(state: state)

            case .reducer(.getDayPrayerTimes(.some(let prayerTimes))):
                state.todaysPrayerTimes = prayerTimes
                return .none

            case let .reducer(.setSha1(sha1, year)):
                state.prayerTimesSha1.setSha1(sha1: sha1, for: year)
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
            let components = Calendar.current.dateComponents(
                [.year, .month, .day], from: state.date
            )
            guard let year = components.year,
                  let month = components.month,
                  let day = components.day
            else { return }

            guard state.checkedYears.contains(year) == false
            else {
                guard let day = prayerTimesLocalRepo.getDayPrayerTimes(
                    year: year, month: month, day: day
                ) else { return }
                await send(
                    .reducer(.getDayPrayerTimes(DayPrayerTimes(from: day))),
                    animation: .default
                )
                return
            }

            let yearSha1 = state.prayerTimesSha1.getSha1(year: year)
            let responseSha = await prayerTimesRemoteRepo.getSha1(year: year)

            var isDirty = false
            var newSha = yearSha1

            switch (yearSha1, responseSha) {
            case let (.some(currentSha), .success(remoteSha)):
                if currentSha == remoteSha { break }
                isDirty = true
                newSha = remoteSha

            case (.none, .success(let remoteSha)):
                isDirty = true
                newSha = remoteSha

            case (.some, .failure):
                break

            case (.none, .failure(.unreachable)):
                await send(.reducer(.setError(.unreachable)))
                return

            case (.none, .failure(.unknown)):
                await send(.reducer(.setError(.unknown)))
                return
            }

            if let newSha, isDirty {
                switch await persistPrayerTimes(year: year) {
                case .success: break
                case .failure(.unreachable): return
                case .failure(.unknown): return
                }
                await send(.reducer(.setSha1(sha1: newSha, year: year)))
                await send(.reducer(.appendCheckedYear(year: year)))
            }

            guard let day = prayerTimesLocalRepo.getDayPrayerTimes(
                year: year, month: month, day: day
            ) else { return }
            await send(
                .reducer(.getDayPrayerTimes(DayPrayerTimes(from: day))),
                animation: .default
            )
        }
    }

    private func persistPrayerTimes(year: Int) async -> Result<(), ServiceError> {
        switch await prayerTimesRemoteRepo.getYearPrayerTimes(year: year) {
        case .success(let daysOfYear):
            prayerTimesLocalRepo.createYearPrayerTimes(
                daysOfYear.map { $0.intoModel }
            )
            return .success(())

        case .failure(let why):
            return .failure(why)
        }
    }
}
