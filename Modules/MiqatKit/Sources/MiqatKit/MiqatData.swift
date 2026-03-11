//
//  MiqatData.swift
//  MiqatKit
//
//  Created by Hamza Jadid on 11/03/2026.
//

import Miqat
import Foundation

public struct MiqatData: Sendable, Equatable {
    public let imsak: Date?
    public let fajr: Date
    public let sunrise: Date
    public let dhuhr: Date
    public let asr: Date
    public let maghrib: Date
    public let ishaa: Date

    public let hijriDay: Int
    public let hijriMonth: Int
    public let hijriYear: Int
    public var hijriLocaleMonth: String? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.dateFormat = "M"

        guard let date = formatter.date(from: "\(self.hijriMonth)")
        else { return nil }

        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }

    init(timestampSecs: TimeInterval, provider: Provider) {
        let prayerTimes = Miqat.PrayerTimes.fromPrecomputed(
            dateUtcTimestampSecs: Int64(timestampSecs),
            provider: .darElFatwa(.beirut)
        )
        self.fajr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.fajr()))
        self.sunrise = Date(timeIntervalSince1970: TimeInterval(prayerTimes.sunrise()))
        self.dhuhr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.dhuhr()))
        self.asr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.asr()))
        self.maghrib = Date(timeIntervalSince1970: TimeInterval(prayerTimes.maghrib()))
        self.ishaa = Date(timeIntervalSince1970: TimeInterval(prayerTimes.ishaa()))

        let hijriDate = hijriDateFromTimestamp(timestampSecs: Int64(timestampSecs))
        self.hijriDay = Int(hijriDate.day)
        self.hijriMonth = Int(hijriDate.month)
        self.hijriYear = Int(hijriDate.year)

        // if ramadan then fill imsak
        self.imsak = if hijriDate.month == 9 {
            Calendar.current.date(byAdding: .minute, value: -20, to: self.fajr)
        } else {
            nil
        }
    }
}
