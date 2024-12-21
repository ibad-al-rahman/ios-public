//
//  SharedState+Keys.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import ComposableArchitecture

extension PersistenceReaderKey where Self == AppStorageKey<Settings.Appearance> {
    static var appearance: Self {
        appStorage("appearance")
    }
}

extension PersistenceReaderKey where Self == FileStorageKey<PrayerTimesOffset> {
    static var prayerTimesOffset: Self {
        fileStorage(
            .documentsDirectory.appending(component: "prayerTimesOffset.json")
        )
    }
}

extension PersistenceReaderKey where Self == FileStorageKey<PrayerTimesSha1> {
    static var prayerTimesSha1: Self {
        fileStorage(
            .documentsDirectory.appending(component: "prayerTimesSha1.json")
        )
    }
}
