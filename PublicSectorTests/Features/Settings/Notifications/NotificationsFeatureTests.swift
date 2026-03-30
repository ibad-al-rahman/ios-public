//
//  NotificationsFeatureTests.swift
//  PublicSector
//
//  Created by Hamza Jadid on 30/03/2026.
//

import ComposableArchitecture
import Testing
@testable import PublicSector

@Suite
struct NotificationsFeatureTests {
    @Test
    func toggleOnWhenAlreadyAuthorized() async {
        let store = TestStore(initialState: NotificationsFeature.State()) {
            NotificationsFeature()
        } withDependencies: {
            $0.permissions.getPushNotificationPermissionStatus = { .authorized }
            $0.prayerTimesNotificationScheduler.scheduleNotifications = {}
        }

        await store.send(.binding(.set(\.notificationsEnabled, true))) {
            $0.$notificationsEnabled.withLock { $0 = true }
        }
    }

    @Test
    func toggleOnWhenNotDeterminedAndGranted() async {
        let store = TestStore(initialState: NotificationsFeature.State()) {
            NotificationsFeature()
        } withDependencies: {
            $0.permissions.getPushNotificationPermissionStatus = { .notDetermined }
            $0.permissions.requestPushNotificationPermission = { true }
            $0.prayerTimesNotificationScheduler.scheduleNotifications = {}
        }

        await store.send(.binding(.set(\.notificationsEnabled, true))) {
            $0.$notificationsEnabled.withLock { $0 = true }
        }
        await store.receive(\.reducer.permissionResponse.success)
    }

    @Test
    func toggleOnWhenDeniedShowsAlert() async {
        let store = TestStore(initialState: NotificationsFeature.State()) {
            NotificationsFeature()
        } withDependencies: {
            $0.permissions.getPushNotificationPermissionStatus = { .denied }
            $0.prayerTimesNotificationScheduler.scheduleNotifications = {}
        }

        await store.send(.binding(.set(\.notificationsEnabled, true))) {
            $0.$notificationsEnabled.withLock { $0 = true }
        }
        await store.receive(\.reducer.permissionResponse.success) {
            $0.$notificationsEnabled.withLock { $0 = false }
            $0.destination = .alert(.unauthorizedNotificationPermission)
        }
    }

    @Test
    func toggleOnWhenPermissionRequestThrows() async {
        struct PermissionError: Error {}

        let store = TestStore(initialState: NotificationsFeature.State()) {
            NotificationsFeature()
        } withDependencies: {
            $0.permissions.getPushNotificationPermissionStatus = { .notDetermined }
            $0.permissions.requestPushNotificationPermission = { throw PermissionError() }
            $0.prayerTimesNotificationScheduler.scheduleNotifications = {}
        }

        await store.send(.binding(.set(\.notificationsEnabled, true))) {
            $0.$notificationsEnabled.withLock { $0 = true }
        }
        await store.receive(\.reducer.permissionResponse.failure) {
            $0.$notificationsEnabled.withLock { $0 = false }
        }
    }

    @Test
    func toggleOffSkipsEffects() async {
        var state = NotificationsFeature.State()
        state.$notificationsEnabled.withLock { $0 = true }

        let store = TestStore(initialState: state) {
            NotificationsFeature()
        } withDependencies: {
            $0.prayerTimesNotificationScheduler.scheduleNotifications = {
                Issue.record("scheduleNotifications should not be called when toggling off")
            }
        }

        await store.send(.binding(.set(\.notificationsEnabled, false))) {
            $0.$notificationsEnabled.withLock { $0 = false }
        }
    }

    @Test
    func alertOpenSettingsTapOpensSettings() async {
        var state = NotificationsFeature.State()
        state.destination = .alert(.unauthorizedNotificationPermission)

        var didOpenSettings = false
        let store = TestStore(initialState: state) {
            NotificationsFeature()
        } withDependencies: {
            $0.externalDeepLinks.appSettings = { didOpenSettings = true }
        }

        await store.send(.dependent(.destination(.presented(.alert(.openSettings))))) {
            $0.destination = nil
        }

        #expect(didOpenSettings)
    }

    @Test
    func alertCancelDismissesWithNoSideEffects() async {
        var state = NotificationsFeature.State()
        state.destination = .alert(.unauthorizedNotificationPermission)

        let store = TestStore(initialState: state) {
            NotificationsFeature()
        } withDependencies: {
            $0.externalDeepLinks.appSettings = {
                Issue.record("appSettings should not be called on cancel")
            }
        }

        await store.send(.dependent(.destination(.presented(.alert(.cancel))))) {
            $0.destination = nil
        }
    }

    @Test
    func prayerTimesNotificationsBindingSchedules() async {
        var state = NotificationsFeature.State()
        state.$notificationsEnabled.withLock { $0 = true }

        let scheduleCallCount = LockIsolated(0)
        let store = TestStore(initialState: state) {
            NotificationsFeature()
        } withDependencies: {
            $0.prayerTimesNotificationScheduler.scheduleNotifications = {
                scheduleCallCount.withValue { val in val += 1 }
            }
        }

        await store.send(.binding(.set(\.prayerTimesNotifications, Settings.PrayerTimesNotifications(fajr: true)))) {
            $0.$prayerTimesNotifications.withLock { $0 = Settings.PrayerTimesNotifications(fajr: true) }
        }

        #expect(scheduleCallCount.value == 1)
    }
}
