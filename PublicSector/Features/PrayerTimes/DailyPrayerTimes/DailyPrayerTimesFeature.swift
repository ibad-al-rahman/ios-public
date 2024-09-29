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
        var date: Date = .now
        var currentDatePrayerTimes: DayPrayerTimes = .init(date: .now)

        var hijriFormatedDate: String {
            let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ar")
            formatter.calendar = islamicCalendar
            formatter.dateFormat = "d MMMM yyyy"
            return formatter.string(from: date)
        }
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)

        enum ViewAction {
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
        EmptyReducer()
    }
}

