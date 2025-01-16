//
//  SharedState+Keys.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import Sharing

extension SharedKey where Self == AppStorageKey<Settings.Appearance> {
    static var appearance: Self {
        appStorage("appearance")
    }
}

extension SharedKey where Self == FileStorageKey<PrayerTimesOffset> {
    static var prayerTimesOffset: Self {
        fileStorage(
            .documentsDirectory.appending(component: "prayerTimesOffset.json")
        )
    }
}

extension SharedKey where Self == FileStorageKey<PrayerTimesSha1> {
    static var prayerTimesSha1: Self {
        fileStorage(
            .documentsDirectory.appending(component: "prayerTimesSha1.json")
        )
    }
}
