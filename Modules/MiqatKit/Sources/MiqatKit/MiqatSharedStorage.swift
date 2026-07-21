//
//  MiqatSharedStorage.swift
//  MiqatKit
//
//  Created by Hamza Jadid on 19/07/2026.
//

import Foundation
import Sharing

/// App Group shared between the main app and its widget extension. The persisted
/// calculation method lives in this container so both read the same value.
public let miqatAppGroupID = "group.com.ibadalrahman.PublicSector"

extension URL {
    /// URL to a file inside the shared App Group container.
    ///
    /// Traps with a clear message if the container is unavailable, which only happens when the
    /// App Group entitlement is missing or misconfigured — a build/provisioning error, not a
    /// runtime condition to recover from.
    public static func miqatAppGroup(_ path: String) -> URL {
        guard let container = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: miqatAppGroupID)
        else {
            fatalError(
                "Missing App Group container '\(miqatAppGroupID)'. "
                    + "Check the App Group entitlement on the app and widget targets."
            )
        }
        return container.appending(path: path)
    }
}

extension SharedKey where Self == FileStorageKey<MiqatPrayerTimesCalculationMethod>.Default {
    /// The persisted prayer-times calculation method, shared with the widget.
    public static var calculationMethod: Self {
        Self[
            .fileStorage(.miqatAppGroup("miqatCalculationMethod.json")),
            default: .default
        ]
    }
}
