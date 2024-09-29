//
//  DailyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct DailyPrayerTimesFeature {
    @ObservableState
    struct State: Equatable {
        @SharedReader(.language) var language = .system
        var date: Date = .now
        var currentDatePrayerTimes: DayPrayerTimes = .init(date: .now)
        var hijriFormattedDate: String?
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onAppear
            case onTapShare
        }

        @CasePathable
        enum ReducerAction { }

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
                let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)
                let formatter = DateFormatter()
                formatter.calendar = islamicCalendar
                formatter.locale = state.language.locale
                formatter.dateFormat = "d MMMM yyyy"
                state.hijriFormattedDate = formatter.string(from: state.date)
                return .none

            default: return .none
            }
        }
    }
}

