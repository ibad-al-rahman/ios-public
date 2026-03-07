//
//  PrayerTimes.swift
//  IbadAzan
//
//  Created by haljadid on 07/03/2026.
//

import Azan
import Foundation

public struct PrayerTimes {
    public let fajr: Date
    public let sunrise: Date
    public let dhuhr: Date
    public let asr: Date
    public let maghrib: Date
    public let ishaa: Date

    init(from prayerTimes: Azan.PrayerTimes) {
        self.fajr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.fajr()))
        self.sunrise = Date(timeIntervalSince1970: TimeInterval(prayerTimes.sunrise()))
        self.dhuhr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.dhuhr()))
        self.asr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.asr()))
        self.maghrib = Date(timeIntervalSince1970: TimeInterval(prayerTimes.maghrib()))
        self.ishaa = Date(timeIntervalSince1970: TimeInterval(prayerTimes.ishaa()))
    }
}
