//
//  LocalDataSource.swift
//  IbadPrayerTimesRepository
//
//  Created by Hamza Jadid on 16/01/2025.
//

import Foundation
import IdentifiedCollections
import Sharing
import OSLog

public struct YearPrayerTimesEntity: Codable, Sendable {
    public let year: IdentifiedArrayOf<DayPrayerTimesEntity>
    public let sha1: String

    public static let empty = Self(year: IdentifiedArray(), sha1: "")

    public var isEmpty: Bool {
        self.year.isEmpty
    }

    public init(year: IdentifiedArrayOf<DayPrayerTimesEntity>, sha1: String) {
        self.year = year
        self.sha1 = sha1
    }

    public func getDayPrayerTimes(year: Int, month: Int, day: Int) -> DayPrayerTimesEntity? {
        let idStr = String(format: "%04d%02d%02d", year, month, day)
        Logger.local.info("Searching for \(idStr) prayer time")
        guard let id = Int(idStr),
              let day = self.year[id: id]
        else {
            Logger.local.warning("Couldn't found \(idStr) prayer time")
            return nil
        }
        Logger.local.info("Found \(idStr) \(day.gregorian)")
        return day
    }
}

public struct YearWeekPrayerTimesEntity: Codable, Sendable {
    public let year: IdentifiedArrayOf<WeekPrayerTimesEntity>

    public static let empty = Self(year: IdentifiedArray())

    public var isEmpty: Bool {
        self.year.isEmpty
    }

    public init(year: IdentifiedArrayOf<WeekPrayerTimesEntity>) {
        self.year = year
    }

    public func getWeekPrayerTimes(weekId: Int) -> WeekPrayerTimesEntity? {
        guard let week = self.year[id: weekId]
        else {
            Logger.local.warning("Couldn't found \(weekId) week prayer time")
            return nil
        }
        return week
    }

    public struct WeekPrayerTimesEntity: Codable, Identifiable, Sendable {
        public let id: Int
        public let mon: DayPrayertimesEntity?
        public let tue: DayPrayertimesEntity?
        public let wed: DayPrayertimesEntity?
        public let thu: DayPrayertimesEntity?
        public let fri: DayPrayertimesEntity?
        public let sat: DayPrayertimesEntity?
        public let sun: DayPrayertimesEntity?
        public let hadith: HadithEntity?
    }

    public struct DayPrayertimesEntity: Codable, Identifiable, Sendable {
        public let id: Int
        public let gregorian: String
        public let hijri: String
        public let prayerTimes: PrayerTimesEntity
    }

    public struct HadithEntity: Codable, Sendable {
        public let hadith: String
        public let note: String?
    }
}

public struct DayPrayerTimesEntity: Codable, Identifiable, Sendable {
    public let id: Int
    public let weekId: Int
    public let gregorian: String
    public let hijri: String
    public let prayerTimes: PrayerTimesEntity
    public let event: DayEventEntity?
}

public struct PrayerTimesEntity: Codable, Sendable {
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let ishaa: String
}

public struct DayEventEntity: Codable, Sendable {
    public let ar: String
    public let en: String?
}

public struct PrayerTimesEntityFileManager {
    static let baseUrl = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: "group.com.ibadalrahman.PublicSector"
    )?.appendingPathComponent(
        "Documents", conformingTo: .directory
    ) ?? .documentsDirectory

    public static func removeDocuments() throws {
        try FileManager.default.removeItem(at: baseUrl)
        try FileManager.default.removeItem(at: .documentsDirectory)
    }
}

public extension SharedKey where Self == FileStorageKey<YearPrayerTimesEntity> {
    static func localDayPrayerTimes(year: Int) -> Self {
        fileStorage(
            PrayerTimesEntityFileManager.baseUrl
                .appendingPathComponent("prayerTimes", conformingTo: .directory)
                .appendingPathComponent("days", conformingTo: .directory)
                .appending(component: "\(year).json")
        )
    }
}

public extension SharedKey where Self == FileStorageKey<YearWeekPrayerTimesEntity> {
    static func localWeekPrayerTimes(year: Int) -> Self {
        fileStorage(
            PrayerTimesEntityFileManager.baseUrl
                .appendingPathComponent("prayerTimes", conformingTo: .directory)
                .appendingPathComponent("weeks", conformingTo: .directory)
                .appending(component: "\(year).json")
        )
    }
}

public typealias PrayerTimesSha1 = [String: String]

public extension PrayerTimesSha1 {
    func getSha1(year: Int) -> String? {
        let yearString = String(format: "%d", year)
        return self[yearString]
    }

    mutating func setSha1(sha1: String, for year: Int) {
        let yearString = String(format: "%d", year)
        self[yearString] = sha1
    }
}

public extension SharedKey where Self == FileStorageKey<PrayerTimesSha1> {
    static var prayerTimesSha1: Self {
        fileStorage(
            PrayerTimesEntityFileManager.baseUrl
                .appendingPathComponent("prayerTimesSha1.json")
        )
    }
}

extension Logger {
    static let local = Logger(
        subsystem: "com.ibadalrahman.PublicSector",
        category: "IbadPrayerTimesRepository.LocalDataSource"
    )
}
