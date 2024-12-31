//
//  AppInfo.swift
//  PublicSector
//
//  Created by Hamza Jadid on 01/01/2025.
//

import Dependencies
import DependenciesMacros
import Foundation
import UIKit

@DependencyClient
struct AppInfo: Sendable {
    var version: @Sendable () -> String = { "" }
    var buildNumber: @Sendable () -> String = { "" }
}

extension AppInfo: DependencyKey {
    static let liveValue: AppInfo = {
        AppInfo(
            version: { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String },
            buildNumber: { Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String }
        )
    }()
}

extension AppInfo {
    static let testValue: AppInfo = {
        AppInfo()
    }()
}

extension DependencyValues {
    var appInfo: AppInfo {
        get { self[AppInfo.self] }
        set { self[AppInfo.self] = newValue }
    }
}
