//
//  AppMetadata.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct AppMetadata {
    var bundleId: () -> String = { "" }
}

extension AppMetadata: DependencyKey {
    static var liveValue: AppMetadata {
        AppMetadata(
            bundleId: { Bundle.main.bundleIdentifier! }
        )
    }
}

extension DependencyValues {
    var appMetadata: AppMetadata {
        get { self[AppMetadata.self] }
        set { self[AppMetadata.self] = newValue }
    }
}
