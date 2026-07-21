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

extension SharedKey where Self == FileStorageKey<Settings.AdhkarNotifications> {
    static var adhkarNotifications: Self {
        fileStorage(.documentsDirectory.appending(path: "adhkarNotifications.json"))
    }
}

extension SharedKey where Self == FileStorageKey<Settings.SelectedLocation?> {
    // Stored in the shared App Group container (not `.documentsDirectory`) so the widget can
    // read the same location and compute identical astronomical prayer times as the app.
    static var selectedLocation: Self {
        fileStorage(.documentsDirectory.appending(path: "selectedLocation.json"))
    }
}
