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

extension SharedKey where Self == AppStorageKey<Bool> {
    static var notificationsEnabled: Self {
        appStorage("notificationsEnabled")
    }
}

extension SharedKey where Self == FileStorageKey<Settings.PrayerTimesNotifications> {
    static var prayerTimesNotifications: Self {
        fileStorage(.documentsDirectory.appending(path: "prayerTimesNotifications.json"))
    }
}

extension SharedKey where Self == FileStorageKey<Settings.SelectedLocation?> {
    static var selectedLocation: Self {
        fileStorage(.documentsDirectory.appending(path: "selectedLocation.json"))
    }
}
