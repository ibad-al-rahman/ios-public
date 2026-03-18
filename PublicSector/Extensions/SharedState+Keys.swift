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

    static var fajrNotificationEnabled: Self {
        appStorage("fajrNotificationEnabled")
    }

    static var dhuhrNotificationEnabled: Self {
        appStorage("dhuhrNotificationEnabled")
    }

    static var asrNotificationEnabled: Self {
        appStorage("asrNotificationEnabled")
    }

    static var maghribNotificationEnabled: Self {
        appStorage("maghribNotificationEnabled")
    }

    static var ishaaNotificationEnabled: Self {
        appStorage("ishaaNotificationEnabled")
    }
}
