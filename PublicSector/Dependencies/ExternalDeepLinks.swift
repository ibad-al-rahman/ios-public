//
//  ExternalDeepLinks.swift
//  PublicSector
//
//  Created by Hamza Jadid on 08/11/2024.
//

import Dependencies
import DependenciesMacros
import UIKit

@DependencyClient
struct ExternalDeepLinks: Sendable {
    var appSettings: @Sendable () async -> Void
    var appStoreRatePage: @Sendable () async -> Void
    var appStorePage: @Sendable () async -> Void
}

extension ExternalDeepLinks: DependencyKey {
    static let liveValue: ExternalDeepLinks = {
        ExternalDeepLinks(
            appSettings: { @MainActor in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    await UIApplication.shared.open(url)
                }
            },
            appStoreRatePage: { @MainActor in
                if let url = URL(string: "itms-apps://apple.com/app/id6739705601?action=write-review&mt=8") {
                    await UIApplication.shared.open(url)
                }
            },
            appStorePage: { @MainActor in
                if let url = URL(string: "itms-apps://apple.com/app/id6739705601") {
                    await UIApplication.shared.open(url)
                }
            }
        )
    }()
}

extension ExternalDeepLinks {
    static let testValue: ExternalDeepLinks = {
        ExternalDeepLinks()
    }()
}

extension DependencyValues {
    var externalDeepLinks: ExternalDeepLinks {
        get { self[ExternalDeepLinks.self] }
        set { self[ExternalDeepLinks.self] = newValue }
    }
}
