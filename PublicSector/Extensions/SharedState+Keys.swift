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

extension SharedKey where Self == AppStorageKey<Bool> {
    static var adhkarDailyEnabled: Self { appStorage("adhkarDailyEnabled") }
    static var adhkarMorningEnabled: Self { appStorage("adhkarMorningEnabled") }
    static var adhkarEveningEnabled: Self { appStorage("adhkarEveningEnabled") }
}

extension SharedKey where Self == AppStorageKey<Double> {
    static var adhkarDailyTime: Self { appStorage("adhkarDailyTime") }
    static var adhkarMorningTime: Self { appStorage("adhkarMorningTime") }
    static var adhkarEveningTime: Self { appStorage("adhkarEveningTime") }
}
