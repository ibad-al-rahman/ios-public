//
//  PrayerTimesStorage.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 16/01/2025.
//

import Foundation
import IdentifiedCollections
import Sharing
import OSLog

public struct YearPrayerTimesStorage: Codable, Sendable {
    public let year: IdentifiedArrayOf<DayPrayerTimesStorage>
    public let sha1: String

    public static let empty = Self(year: IdentifiedArray(), sha1: "")

    public var isEmpty: Bool {
        self.year.isEmpty
    }

    public init(year: IdentifiedArrayOf<DayPrayerTimesStorage>, sha1: String) {
        self.year = year
        self.sha1 = sha1
    }

    public func getDayPrayerTimes(year: Int, month: Int, day: Int) -> DayPrayerTimesStorage? {
        let idStr = String(format: "%04d%02d%02d", year, month, day)
        Logger.local.info("Searching for \(idStr) prayer time")
        guard let id = Int(idStr),
              let day = self.year[id: id]
        else {
            Logger.local.warning("Couldn't found \(idStr) prayer time")
            return nil
        }
        return day
    }
}

public struct WeekPrayerTimesStorage: Codable, Identifiable, Sendable {
    public let id: Int
    public let mon: DayPrayertimesStorage?
    public let tue: DayPrayertimesStorage?
    public let wed: DayPrayertimesStorage?
    public let thu: DayPrayertimesStorage?
    public let fri: DayPrayertimesStorage?
    public let sat: DayPrayertimesStorage?
    public let sun: DayPrayertimesStorage?

    public struct DayPrayertimesStorage: Codable, Identifiable, Sendable {
        public let id: Int
        public let gregorian: String
        public let hijri: String
        public let prayerTimes: PrayerTimesStorage
    }
}

public struct DayPrayerTimesStorage: Codable, Identifiable, Sendable {
    public let id: Int
    public let weekId: Int
    public let gregorian: String
    public let hijri: String
    public let prayerTimes: PrayerTimesStorage
    public let event: DayEventStorage?
}

public struct PrayerTimesStorage: Codable, Sendable {
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let ishaa: String
}

public struct DayEventStorage: Codable, Sendable {
    public let ar: String
    public let en: String?
}

public extension SharedKey where Self == FileStorageKey<YearPrayerTimesStorage> {
    static func localDayPrayerTimes(year: Int) -> Self {
        let baseUrl = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.ibadalrahman.PublicSector"
        )?.appendingPathComponent(
            "Documents", conformingTo: .directory
        ) ?? .documentsDirectory
        return fileStorage(
            baseUrl
                .appendingPathComponent("prayerTimes", conformingTo: .directory)
                .appendingPathComponent("days", conformingTo: .directory)
                .appending(component: "\(year).json")
        )
    }
}
