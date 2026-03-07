//
//  AppFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import IbadAnalytics

@Reducer
struct AppFeature {
    enum Tab {
        case prayerTimes
        case events
        case settings
        case adhkar
    }

    @ObservableState
    struct State: Equatable {
        @SharedReader(.appearance) var appearance = .system

        var selectedTab: Tab = .prayerTimes
        var prayerTimes = PrayerTimesFeature.State()
        var events = EventsFeature.State()
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
        enum ReducerAction {
            case openAdhkarTab
            case openAdhkarCategory(AdhkarCategory)
        }
        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case prayerTimes(PrayerTimesFeature.Action)
            case events(EventsFeature.Action)
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
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { send in
                    for await notification in NotificationCenter.default.notifications(named: .adhkarNotificationTapped) {
                        guard let category = notification.userInfo?["category"] as? String else { continue }
                        switch category {
                        case "daily": await send(.reducer(.openAdhkarTab))
                        case "morning": await send(.reducer(.openAdhkarCategory(.morning)))
                        case "evening": await send(.reducer(.openAdhkarCategory(.evening)))
                        default: break
                        }
                    }
                }

            case .reducer(.openAdhkarTab):
                state.selectedTab = .adhkar
                return .none

            case .reducer(.openAdhkarCategory(let category)):
                state.selectedTab = .adhkar
                switch category {
                case .morning:
                    state.adhkar.destination = .morning(DhikrListFeature.State(category: .morning))
                case .evening:
                    state.adhkar.destination = .evening(DhikrListFeature.State(category: .evening))
                default:
                    break
                }
                return .none

            default:
                return .none
            }
        }
        Scope(state: \.prayerTimes, action: \.dependent.prayerTimes) {
            PrayerTimesFeature()
        }
        Scope(state: \.events, action: \.dependent.events) {
            EventsFeature()
        }
        Scope(state: \.settings, action: \.dependent.settings) {
            SettingsFeature()
        }
        Scope(state: \.adhkar, action: \.dependent.adhkar) {
            AdhkarFeature()
        }
    }
}
