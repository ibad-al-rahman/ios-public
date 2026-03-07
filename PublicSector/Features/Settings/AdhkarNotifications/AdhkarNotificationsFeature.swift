//
//  AdhkarNotificationsFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/03/2026.
//

import ComposableArchitecture
import UserNotifications

private let dailyIdentifier = "adhkar.daily"
private let morningIdentifier = "adhkar.morning"
private let eveningIdentifier = "adhkar.evening"

private func defaultTime(hour: Int) -> Double {
    Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())?.timeIntervalSince1970 ?? 0
}

@Reducer
struct AdhkarNotificationsFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.adhkarDailyEnabled) var dailyEnabled: Bool = false
        @Shared(.adhkarDailyTime) var dailyTimeInterval: Double = defaultTime(hour: 12)

        @Shared(.adhkarMorningEnabled) var morningEnabled: Bool = false
        @Shared(.adhkarMorningTime) var morningTimeInterval: Double = defaultTime(hour: 9)

        @Shared(.adhkarEveningEnabled) var eveningEnabled: Bool = false
        @Shared(.adhkarEveningTime) var eveningTimeInterval: Double = defaultTime(hour: 18)

        var isLoading: Bool = false

        var dailyTime: Date { Date(timeIntervalSince1970: dailyTimeInterval) }
        var morningTime: Date { Date(timeIntervalSince1970: morningTimeInterval) }
        var eveningTime: Date { Date(timeIntervalSince1970: eveningTimeInterval) }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case onAppear
            case onDailyToggle(Bool)
            case onDailyTimeChanged(Date)
            case onMorningToggle(Bool)
            case onMorningTimeChanged(Date)
            case onEveningToggle(Bool)
            case onEveningTimeChanged(Date)
        }

        @CasePathable
        enum ReducerAction {
            case scheduled(Slot)
            case permissionDenied
            case onAppearResult(daily: Bool, morning: Bool, evening: Bool)
        }

        enum Slot: Equatable { case daily, morning, evening }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    @Dependency(\.permissions) private var permissions

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { send in
                    let settings = await UNUserNotificationCenter.current().notificationSettings()
                    let granted = settings.authorizationStatus == .authorized
                    let pending = await UNUserNotificationCenter.current().pendingNotificationRequests()
                    let ids = Set(pending.map(\.identifier))
                    await send(.reducer(.onAppearResult(
                        daily: granted && ids.contains(dailyIdentifier),
                        morning: granted && ids.contains(morningIdentifier),
                        evening: granted && ids.contains(eveningIdentifier)
                    )))
                }

            case .view(.onDailyToggle(let enabled)):
                state.isLoading = true
                if enabled {
                    let time = state.dailyTime
                    return .run { send in
                        let granted = (try? await permissions.pushNotificationPermission()) ?? false
                        if granted {
                            await scheduleDailyNotification(at: time)
                            await send(.reducer(.scheduled(.daily)))
                        } else {
                            await send(.reducer(.permissionDenied))
                        }
                    }
                } else {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dailyIdentifier])
                    state.$dailyEnabled.withLock { $0 = false }
                    state.isLoading = false
                    return .none
                }

            case .view(.onDailyTimeChanged(let time)):
                state.$dailyTimeInterval.withLock { $0 = time.timeIntervalSince1970 }
                guard state.dailyEnabled else { return .none }
                return .run { _ in await scheduleDailyNotification(at: time) }

            case .view(.onMorningToggle(let enabled)):
                state.isLoading = true
                if enabled {
                    let time = state.morningTime
                    return .run { send in
                        let granted = (try? await permissions.pushNotificationPermission()) ?? false
                        if granted {
                            await scheduleMorningNotification(at: time)
                            await send(.reducer(.scheduled(.morning)))
                        } else {
                            await send(.reducer(.permissionDenied))
                        }
                    }
                } else {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [morningIdentifier])
                    state.$morningEnabled.withLock { $0 = false }
                    state.isLoading = false
                    return .none
                }

            case .view(.onMorningTimeChanged(let time)):
                state.$morningTimeInterval.withLock { $0 = time.timeIntervalSince1970 }
                guard state.morningEnabled else { return .none }
                return .run { _ in await scheduleMorningNotification(at: time) }

            case .view(.onEveningToggle(let enabled)):
                state.isLoading = true
                if enabled {
                    let time = state.eveningTime
                    return .run { send in
                        let granted = (try? await permissions.pushNotificationPermission()) ?? false
                        if granted {
                            await scheduleEveningNotification(at: time)
                            await send(.reducer(.scheduled(.evening)))
                        } else {
                            await send(.reducer(.permissionDenied))
                        }
                    }
                } else {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [eveningIdentifier])
                    state.$eveningEnabled.withLock { $0 = false }
                    state.isLoading = false
                    return .none
                }

            case .view(.onEveningTimeChanged(let time)):
                state.$eveningTimeInterval.withLock { $0 = time.timeIntervalSince1970 }
                guard state.eveningEnabled else { return .none }
                return .run { _ in await scheduleEveningNotification(at: time) }

            case .reducer(.onAppearResult(let daily, let morning, let evening)):
                state.$dailyEnabled.withLock { $0 = daily }
                state.$morningEnabled.withLock { $0 = morning }
                state.$eveningEnabled.withLock { $0 = evening }
                state.isLoading = false
                return .none

            case .reducer(.scheduled(let slot)):
                switch slot {
                case .daily: state.$dailyEnabled.withLock { $0 = true }
                case .morning: state.$morningEnabled.withLock { $0 = true }
                case .evening: state.$eveningEnabled.withLock { $0 = true }
                }
                state.isLoading = false
                return .none

            case .reducer(.permissionDenied):
                state.isLoading = false
                return .none

            default:
                return .none
            }
        }
    }
}

private func scheduleMorningNotification(at date: Date) async {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [morningIdentifier])

    let content = UNMutableNotificationContent()
    content.title = "أذكار الصباح"
    content.body = "حان وقت أذكار الصباح"
    content.sound = .default
    content.userInfo = ["category": "morning"]

    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    let request = UNNotificationRequest(identifier: morningIdentifier, content: content, trigger: trigger)
    try? await center.add(request)
}

private func scheduleEveningNotification(at date: Date) async {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [eveningIdentifier])

    let content = UNMutableNotificationContent()
    content.title = "أذكار المساء"
    content.body = "حان وقت أذكار المساء"
    content.sound = .default
    content.userInfo = ["category": "evening"]

    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    let request = UNNotificationRequest(identifier: eveningIdentifier, content: content, trigger: trigger)
    try? await center.add(request)
}

private func scheduleDailyNotification(at date: Date) async {
    let allAdhkar = AdhkarData.morning + AdhkarData.evening + AdhkarData.afterPrayer + AdhkarData.wakingUp + AdhkarData.generalSupplications
    guard let dhikr = allAdhkar.randomElement() else { return }

    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [dailyIdentifier])

    let content = UNMutableNotificationContent()
    content.title = "ذكر اليوم"
    content.body = dhikr.ar
    content.sound = .default
    content.userInfo = ["category": "daily"]

    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    let request = UNNotificationRequest(identifier: dailyIdentifier, content: content, trigger: trigger)
    try? await center.add(request)
}
