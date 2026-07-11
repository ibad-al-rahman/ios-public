//
//  DeepLinkParser.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import Dependencies
import DependenciesMacros
import Foundation

/// Turns an incoming deep link into a `RootRoute`. The live implementation runs the
/// URLRouting router; tests can substitute a canned result.
@DependencyClient
struct DeepLinkParser: Sendable {
    var parse: @Sendable (_ url: URL) -> RootRoute?
}

extension DeepLinkParser: DependencyKey {
    static let liveValue = DeepLinkParser(
        parse: { try? RootRoute.router.match(url: $0) }
    )
}

extension DeepLinkParser {
    static let testValue = DeepLinkParser()
}

extension DependencyValues {
    var deepLinkParser: DeepLinkParser {
        get { self[DeepLinkParser.self] }
        set { self[DeepLinkParser.self] = newValue }
    }
}
