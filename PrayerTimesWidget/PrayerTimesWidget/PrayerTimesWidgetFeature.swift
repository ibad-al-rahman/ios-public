//
//  PrayerTimesWidgetFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import Foundation
import MiqatKit

@Reducer
struct PrayerTimesWidgetFeature {
    @Dependency(\.miqatService) private var miqatService

    @ObservableState
    struct State: Equatable {
        let date: Date
        let currentPrayer: Prayer
        let nextPrayer: Prayer
        let nextPrayerDate: Date
        var todaysPrayerTimes: DayPrayerTimes?
    }

    enum Action {
        case onAppear
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let tzOffset = TimeZone.current.secondsFromGMT()
                let timestamp = state.date.timeIntervalSince1970 + TimeInterval(tzOffset)
                let miqatData = miqatService.getMiqatData(timestampSecs: timestamp, provider: .darElFatwa(.beirut))
                state.todaysPrayerTimes = DayPrayerTimes(from: miqatData)
                return .none
            }
        }
    }
}
