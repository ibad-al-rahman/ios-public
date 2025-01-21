//
//  AppDelegate.swift
//  PublicSector
//
//  Created by Hamza Jadid on 21/01/2025.
//

import FirebaseCore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
