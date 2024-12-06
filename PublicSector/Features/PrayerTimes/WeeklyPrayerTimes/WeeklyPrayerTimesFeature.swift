//
//  WeeklyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct WeeklyPrayerTimesFeature {
    @ObservableState
    struct State: Equatable {
        var week: [DayPrayerTimes] = []

        init() {
            self.week = []
        }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

        enum ViewAction { }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
