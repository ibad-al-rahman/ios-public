//
//  AppFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import IbadAnalytics

@Reducer
struct AppFeature {
    enum Tab {
        case prayerTimes
        case search
        case settings
        case adhkar
    }

    @ObservableState
    struct State: Equatable {
        @SharedReader(.appearance) var appearance = .system

        var selectedTab: Tab = .prayerTimes
        var prayerTimes = PrayerTimesFeature.State()
        var search = SearchFeature.State()
        var settings = SettingsFeature.State()
        var adhkar = AdhkarFeature.State()
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onAppear
        }
        @CasePathable
        enum ReducerAction { }
        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case prayerTimes(PrayerTimesFeature.Action)
            case search(SearchFeature.Action)
            case settings(SettingsFeature.Action)
            case adhkar(AdhkarFeature.Action)
        }
    }

    var body: some ReducerOf<Self> {
        AnalyticsReducer { state, action in
            switch action {
            case .view(.onAppear):
                return .screen(name: "App")

            default:
                return .none
            }
        }
        BindingReducer()
        Scope(state: \.prayerTimes, action: \.dependent.prayerTimes) {
            PrayerTimesFeature()
        }
        Scope(state: \.search, action: \.dependent.search) {
            SearchFeature()
        }
        Scope(state: \.settings, action: \.dependent.settings) {
            SettingsFeature()
        }
        Scope(state: \.adhkar, action: \.dependent.adhkar) {
            AdhkarFeature()
        }
    }
}
