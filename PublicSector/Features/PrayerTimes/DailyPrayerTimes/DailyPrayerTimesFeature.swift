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
        @SharedReader(.prayerTimesOffset) var offset = .default
        var date: Date = .now
        var hijriFormattedDate: String?
        var todaysPrayerTime = DayPrayerTimes(date: .now)
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
            case updatePrayerOffset
        }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    enum CancelId {
        case offsetTask
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.todaysPrayerTime = DayPrayerTimes(date: .now)
                let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)
                let formatter = DateFormatter()
                formatter.calendar = islamicCalendar
                formatter.dateFormat = "d MMMM yyyy"
                state.hijriFormattedDate = formatter.string(from: state.date)
                state.todaysPrayerTime.offset(state.offset)
                return .run { [offset = state.$offset] send in
                    let response = await prayerTimesRepository.getDayPrayerTimes(2024, 12, 30)
                    print(response)
                    for await _ in offset.publisher.values {
                        await send(.reducer(.updatePrayerOffset))
                    }
                }
                .cancellable(id: CancelId.offsetTask, cancelInFlight: true)

            case .reducer(.updatePrayerOffset):
                state.todaysPrayerTime = DayPrayerTimes(date: .now)
                state.todaysPrayerTime.offset(state.offset)
                return .none

            default: return .none
            }
        }
    }
}
