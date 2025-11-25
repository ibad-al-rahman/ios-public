//
//  PrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct PrayerTimesFeature {
    enum PrayerTimesPicker: CaseIterable, Identifiable {
        case daily
        case weekly

        var id: String {
            switch self {
            case .daily: "daily"
            case .weekly: "weekly"
            }
        }
    }

    @ObservableState
    struct State: Equatable {
        var prayerTimesPicker: PrayerTimesPicker = .daily
        var dailyPrayerState = DailyPrayerTimesFeature.State()
        var weeklyPrayerState = WeeklyPrayerTimesFeature.State()
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction { }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case dailyPrayer(DailyPrayerTimesFeature.Action)
            case weeklyPrayer(WeeklyPrayerTimesFeature.Action)
        }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        EmptyReducer()

        Scope(state: \.dailyPrayerState, action: \.dependent.dailyPrayer) {
            DailyPrayerTimesFeature()
        }

        Scope(state: \.weeklyPrayerState, action: \.dependent.weeklyPrayer) {
            WeeklyPrayerTimesFeature()
        }
    }
}
