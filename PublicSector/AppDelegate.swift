//
//  AppDelegate.swift
//  PublicSector
//
//  Created by Hamza Jadid on 21/01/2025.
//

import FirebaseCore
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    FirebaseCore.FirebaseApp.configure()
    UNUserNotificationCenter.current().delegate = self
    return true
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
