//
//  AdhkarCollectionTests.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import Testing
@testable import PublicSector

@Suite
struct AdhkarCollectionTests {
    @Test
    func notificationIdentifiersMatchScheduler() {
        #expect(AdhkarCollection.morning.notificationIdentifier == "adhkar-morning")
        #expect(AdhkarCollection.evening.notificationIdentifier == "adhkar-evening")
    }

    @Test
    func resolvesCollectionFromNotificationIdentifier() {
        #expect(AdhkarCollection(notificationIdentifier: "adhkar-morning") == .morning)
        #expect(AdhkarCollection(notificationIdentifier: "adhkar-evening") == .evening)
    }

    @Test
    func rejectsUnknownNotificationIdentifier() {
        #expect(AdhkarCollection(notificationIdentifier: "adhkar-midday") == nil)
        #expect(AdhkarCollection(notificationIdentifier: "prayer-fajr") == nil)
    }
}
