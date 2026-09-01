//
//  GetPrayerTimeIntent.swift
//  PublicSector
//
//  Created by Hamza Jadid on 02/09/2026.
//

import AppIntents
import Dependencies
import Foundation
import MiqatKit

/// Returns the time of a selected prayer for a given day, for use in the Shortcuts app and Siri.
///
/// Prayer times are computed offline via `MiqatService`, which reads the user's persisted
/// calculation method and location — the same source the in-app Daily Prayer Times screen uses.
struct GetPrayerTimeIntent: AppIntent {
    static let title: LocalizedStringResource = "Get Prayer Time"
    static let description = IntentDescription("Get the time of a prayer for a given day.")

    @Parameter(title: "Prayer")
    var prayer: PrayerTimeEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Get \(\.$prayer) time")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<Date> {
        @Dependencies.Dependency(\.miqatService) var miqatService
        // Mirror DailyPrayerTimesFeature: shift by the local UTC offset so the timestamp
        // lands on the correct calendar day for prayer-time computation.
        let tzOffset = TimeZone.current.secondsFromGMT()
        let timestamp = Date().timeIntervalSince1970 + TimeInterval(tzOffset)
        let data = miqatService.getMiqatData(timestampSecs: timestamp)
        let time = prayer.time(in: data)

        return .result(value: time)
    }
}
