//
//  NotificationsFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/03/2026.
//

import ComposableArchitecture
import IbadAnalytics
import UserNotifications

@Reducer
struct NotificationsFeature {
    @Dependency(\.permissions) var permissions
    @Dependency(\.externalDeepLinks) var externalDeepLinks
    @Dependency(\.prayerTimesNotificationScheduler.scheduleNotifications) private var scheduleNotifications

    @ObservableState
    struct State: Equatable {
        @Shared(.notificationsEnabled) var notificationsEnabled = false
        @Shared(.fajrNotificationEnabled) var fajrNotificationEnabled = false
        @Shared(.dhuhrNotificationEnabled) var dhuhrNotificationEnabled = false
        @Shared(.asrNotificationEnabled) var asrNotificationEnabled = false
        @Shared(.maghribNotificationEnabled) var maghribNotificationEnabled = false
        @Shared(.ishaaNotificationEnabled) var ishaaNotificationEnabled = false

        @Presents var destination: Destination.State?

        var notificationsDisabled: Bool { !notificationsEnabled }
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
            case permissionResponse(Result<Bool, Error>)
        }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case destination(PresentationAction<Destination.Action>)
        }
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
        Reduce { state, action in
            switch action {
            case let .reducer(.permissionResponse(.success(granted))):
                if !granted {
                    state.$notificationsEnabled.withLock { $0 = false }
                    state.destination = .alert(.unauthorizedNotificationPermission)
                }
                return .none

            case .reducer(.permissionResponse(.failure)):
                state.$notificationsEnabled.withLock { $0 = false }
                return .none

            case .dependent(.destination(.presented(.alert(.openSettings)))):
                return .run { _ in
                    await externalDeepLinks.appSettings()
                }

            case .dependent(.destination(.presented(.alert(.cancel)))):
                return .none

            case .binding(\.notificationsEnabled):
                guard state.notificationsEnabled else {
                    return .none
                }

                return .merge(
                    .run { send in
                        let status = await permissions.getPushNotificationPermissionStatus()

                        switch status {
                        case .authorized:
                            return

                        case .notDetermined, .provisional, .ephemeral:
                            await send(.reducer(.permissionResponse(Result {
                                try await permissions.requestPushNotificationPermission()
                            })))

                        case .denied:
                            await send(.reducer(.permissionResponse(.success(false))))

                        @unknown default:
                            return
                        }
                    },
                    .run { _ in await scheduleNotifications() }
                )

            case .binding(\.fajrNotificationEnabled),
                    .binding(\.dhuhrNotificationEnabled),
                    .binding(\.asrNotificationEnabled),
                    .binding(\.maghribNotificationEnabled),
                    .binding(\.ishaaNotificationEnabled):
                return .run { _ in await scheduleNotifications() }

            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }
}
