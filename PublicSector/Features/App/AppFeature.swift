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
    @Dependency(\.prayerTimesNotificationScheduler.scheduleNotifications) private var scheduleNotifications
    @Dependency(\.adhkarNotificationScheduler.scheduleNotifications) private var scheduleAdhkarNotifications
    @Dependency(\.widgetReloader.reloadAll) private var reloadWidgets

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
            case deepLink(RootRoute)
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
                reloadWidgets()
                return .run { _ in
                    await scheduleNotifications()
                    await scheduleAdhkarNotifications()
                }

            case let .reducer(.deepLink(.adhkar(.collection(collection)))):
                state.selectedTab = .adhkar
                state.adhkar.destination = .tour(AdhkarTourFeature.State(collection: collection))
                return .none

            case .reducer(.deepLink(.prayerTimes)):
                state.selectedTab = .prayerTimes
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
