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
        @Presents var destination: Destination.State?
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onTapEdit
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case dailyPrayer(DailyPrayerTimesFeature.Action)
            case weeklyPrayer(WeeklyPrayerTimesFeature.Action)
            case destination(PresentationAction<Destination.Action>)
        }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .view(.onTapEdit):
                state.destination = .edit(EditPrayerTimesFeature.State())
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }

        Scope(state: \.dailyPrayerState, action: \.dependent.dailyPrayer) {
            DailyPrayerTimesFeature()
        }

        Scope(state: \.weeklyPrayerState, action: \.dependent.weeklyPrayer) {
            WeeklyPrayerTimesFeature()
        }
    }
}
