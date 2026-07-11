//
//  RootRouteTests.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import Foundation
import Testing
import URLRouting
@testable import PublicSector

@Suite
struct RootRouteTests {
    @Test
    func parsesMorningCustomScheme() throws {
        let route = try RootRoute.router.match(url: URL(string: "app://adhkar/morning")!)
        #expect(route == .adhkar(.collection(.morning)))
    }

    @Test
    func parsesEveningCustomScheme() throws {
        let route = try RootRoute.router.match(url: URL(string: "app://adhkar/evening")!)
        #expect(route == .adhkar(.collection(.evening)))
    }

    @Test
    func rejectsUnknownCollection() {
        #expect(throws: (any Error).self) {
            try RootRoute.router.match(url: URL(string: "app://adhkar/midday")!)
        }
    }

    @Test
    func rejectsUnknownHost() {
        #expect(throws: (any Error).self) {
            try RootRoute.router.match(url: URL(string: "app://events/morning")!)
        }
    }
}
