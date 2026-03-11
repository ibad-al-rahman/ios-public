//
//  WeeklyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import MiqatKit

@Reducer
struct WeeklyPrayerTimesFeature {
    @Dependency(\.miqatService) private var miqatService

    @ObservableState
    struct State: Equatable {
        var week: [DayInfo] = []

        var isLoading: Bool { week.isEmpty }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

        enum ViewAction {
            case onAppear
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                fillWeek(state: &state)
                return .none

            default:
                return .none
            }
        }
    }

    private func fillWeek(state: inout State) {
        let calendar = Calendar.current
        let now = Date.now
        let weekday = calendar.component(.weekday, from: now) // 1=Sun…7=Sat
        let daysBack = weekday % 7 // Sat→0, Sun→1, …, Fri→6
        guard let saturday = calendar.date(byAdding: .day, value: -daysBack, to: now) else { return }

        let tzOffset = TimeZone.current.secondsFromGMT()

        state.week = (0..<7).compactMap { i in
            guard let dayDate = calendar.date(byAdding: .day, value: i, to: saturday) else { return nil }
            let timestamp = dayDate.timeIntervalSince1970 + TimeInterval(tzOffset)
            let miqatData = miqatService.getMiqatData(timestampSecs: timestamp, provider: .darElFatwa(.beirut))
            return DayInfo(from: miqatData)
        }
    }
}
