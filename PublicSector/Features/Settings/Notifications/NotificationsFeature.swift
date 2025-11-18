//
//  NotificationsFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/11/2025.
//

import ComposableArchitecture
import IbadAnalytics

@Reducer
struct NotificationsFeature {
    @ObservableState
    struct State: Equatable {
        var notificationsEnabled: Bool = false
        var fajrNotificationEnabled: Bool = false
        var dhuhrNotificationEnabled: Bool = false
        var asrNotificationEnabled: Bool = false
        var maghribNotificationEnabled: Bool = false
        var ishaaNotificationEnabled: Bool = false
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
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        AnalyticsReducer { state, action in
            switch action {
            case .view(.onAppear):
                return .screen(name: "Notifications")
            default:
                return .none
            }
        }
        BindingReducer()
        EmptyReducer()
    }
}
