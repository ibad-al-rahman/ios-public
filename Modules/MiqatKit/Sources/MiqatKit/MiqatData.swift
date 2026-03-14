//
//  MiqatData.swift
//  MiqatKit
//
//  Created by Hamza Jadid on 11/03/2026.
//

import Miqat
import Foundation

public struct MiqatData: Sendable, Equatable, Identifiable {
    public let id: String
    public let gregorian: Date

    public let imsak: Date?
    public let fajr: Date
    public let sunrise: Date
    public let eid: Date?
    public let dhuhr: Date
    public let asr: Date
    public let maghrib: Date
    public let ishaa: Date

    public let hijriDate: MiqatHijriDate

    public let islamicEvents: [IslamicEvent]

    init(timestampSecs: TimeInterval, provider: Provider) {
        let date = Date(timeIntervalSince1970: timestampSecs)
        self.gregorian = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        self.id = formatter.string(from: date)

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

        let hijriDateInfo = HijriDateInfo.fromTimestamp(timestampSecs: Int64(timestampSecs))
        let hijriDate = hijriDateInfo.date()
        self.hijriDate = MiqatHijriDate(from: hijriDate)

        self.islamicEvents = hijriDateInfo.events()

        // if ramadan then fill imsak (fajr - 20mins)
        self.imsak = if hijriDate.month == 9 {
            Calendar.current.date(byAdding: .minute, value: -20, to: self.fajr)
        } else {
            nil
        }

        // if eid then fill eid prayer time (sunrise + 45mins)
        self.eid = if self.islamicEvents.contains(where: { $0 == .eidAlAdha || $0 == .eidAlFitr }) {
            Calendar.current.date(byAdding: .minute, value: 45, to: self.sunrise)
        } else {
            nil
        }
    }
}
