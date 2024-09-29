//
//  UserDefaultsDependency.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import Dependencies
import DependenciesMacros
import Foundation

extension UserDefaults {
    static let publicSector: UserDefaults = {
        @Dependency(\.appMetadata.bundleId) var bundleId
        return UserDefaults(suiteName: "\(bundleId()).defaults")!
    }()
}

enum UserDefaultsKey: String {
    case localeIdentifier = "locale_identifier"
}

@DependencyClient
struct UserDefaultsDependency {
    var setString: (_ value: String, _ forKey: String) -> Void
    var string: (_ forKey: String) -> String?
}

extension UserDefaultsDependency: DependencyKey {
    static var liveValue: UserDefaultsDependency {
        UserDefaultsDependency(
            setString: { UserDefaults.publicSector.set($0, forKey: $1) },
            string: { UserDefaults.publicSector.string(forKey: $0) }
        )
    }
}
