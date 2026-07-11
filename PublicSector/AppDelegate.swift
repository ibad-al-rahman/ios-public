//
//  AppDelegate.swift
//  PublicSector
//
//  Created by Hamza Jadid on 21/01/2025.
//

import Dependencies
import FirebaseCore
import FirebaseMessaging
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    /// FCM topic every device subscribes to. A daily silent-push broadcast to this
    /// topic wakes the app in the background to refresh local prayer notifications.
    static nonisolated let dailyRefreshTopic = "daily-refresh"

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseCore.FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        @Dependency(\.prayerTimesNotificationScheduler) var scheduler
        scheduler.registerBackgroundTask()
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications: \(error)")
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        @Dependency(\.prayerTimesNotificationScheduler) var scheduler
        Task {
            await scheduler.scheduleNotifications()
            completionHandler(.newData)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}

extension AppDelegate: MessagingDelegate {
    nonisolated func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.subscribe(toTopic: Self.dailyRefreshTopic) { error in
            if let error {
                print("Failed to subscribe to \(Self.dailyRefreshTopic): \(error)")
            }
        }
    }
}
