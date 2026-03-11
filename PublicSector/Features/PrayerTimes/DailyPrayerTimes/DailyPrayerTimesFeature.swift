//
//  DailyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import IbadAnalytics
import MiqatKit
import IbadRepositories
import WidgetKit

@Reducer
struct DailyPrayerTimesFeature {
    @Dependency(\.miqatService) private var miqatService

    @ObservableState
    struct State: Equatable {
        var date: Date = .now
        var hasAppeared: Bool = false
        var dayInfo: DayInfo = .init(
            fajr: .now,
            sunrise: .now,
            dhuhr: .now,
            asr: .now,
            maghrib: .now,
            ishaa: .now,
            hijri: ""
        )

        var canResetDate: Bool {
            Calendar.current.isDateInToday(date) == false
        }

        var shareableText: String {
            """
            \(String(localized: "Annual Prayer Times by Ibad"))
            \(dayInfo.hijri)
            \(date.stringDate)

            🌌 \(String(localized: "Fajr")): \(dayInfo.fajr.time) 🌌

            🌄 \(String(localized: "Sunrise")): \(dayInfo.sunrise.time) 🌄

            ☀️ \(String(localized: "Dhuhr")): \(dayInfo.dhuhr.time) ☀️

            🌆 \(String(localized: "Asr")): \(dayInfo.asr.time) 🌆

            🌅 \(String(localized: "Maghrib")): \(dayInfo.maghrib.time) 🌅

            🌃 \(String(localized: "Ishaa")): \(dayInfo.ishaa.time) 🌃

            \(String(localized: "Download app"))
            \(String(localized: "Android")): https://play.google.com/store/apps/details?id=org.ibadalrahman.publicsector
            \(String(localized: "iOS")): https://apps.apple.com/lb/app/ibad-al-rahman/id6739705601
            """
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
        AnalyticsReducer { state, action in
            switch action {
            case .view(.onAppear):
                return .screen(name: "DailyPrayerTimes")

            default:
                return .none
            }
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                if !state.hasAppeared {
                    state.hasAppeared = true
                    state.date = .now
                }
                fillPrayerTimes(state: &state)
                WidgetCenter.shared.reloadAllTimelines()
                return .none

            case .binding(\.date):
                fillPrayerTimes(state: &state)
                return .none

            default: return .none
            }
        }
    }

    private func fillPrayerTimes(state: inout State) {
        let tzOffset = TimeZone.current.secondsFromGMT()
        let timestamp = state.date.timeIntervalSince1970 + TimeInterval(tzOffset)
        let miqatData = miqatService.getMiqatData(
            timestampSecs: timestamp, provider: .darElFatwa(.beirut)
        )
        state.dayInfo.imsak = miqatData.imsak
        state.dayInfo.fajr = miqatData.fajr
        state.dayInfo.sunrise = miqatData.sunrise
        state.dayInfo.dhuhr = miqatData.dhuhr
        state.dayInfo.asr = miqatData.asr
        state.dayInfo.maghrib = miqatData.maghrib
        state.dayInfo.ishaa = miqatData.ishaa

        if let localeMonthName = miqatData.hijriLocaleMonth {
            state.dayInfo.hijri = "\(miqatData.hijriDay) \(localeMonthName) \(miqatData.hijriYear)"
        }
    }
}
