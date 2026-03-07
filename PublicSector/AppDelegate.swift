//
//  AppDelegate.swift
//  PublicSector
//
//  Created by Hamza Jadid on 21/01/2025.
//

import FirebaseCore
import UIKit
import UserNotifications

extension Notification.Name {
    static let adhkarNotificationTapped = Notification.Name("adhkarNotificationTapped")
}

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        migrateNotificationKeys()
        return true
    }

    // Migrates old single-notification keys to the new daily slot keys
    private func migrateNotificationKeys() {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: "adhkarNotificationEnabled") != nil,
              defaults.object(forKey: "adhkarDailyEnabled") == nil else { return }
        defaults.set(defaults.bool(forKey: "adhkarNotificationEnabled"), forKey: "adhkarDailyEnabled")
        defaults.set(defaults.double(forKey: "adhkarNotificationTime"), forKey: "adhkarDailyTime")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let category = userInfo["category"] as? String {
            NotificationCenter.default.post(
                name: .adhkarNotificationTapped,
                object: nil,
                userInfo: ["category": category]
            )
        }
        completionHandler()
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
