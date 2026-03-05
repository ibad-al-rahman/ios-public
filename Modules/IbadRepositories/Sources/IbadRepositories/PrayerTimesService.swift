//
//  PrayerTimesService.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Foundation
import OSLog

struct PrayerTimesService {
    func getSha1(year: Int) async throws -> String {
        let endpoint = PrayerTimesEndpoint.getSha1(
            year: String(format: "%04d", year)
        )
        guard let url = URL(string: endpoint.url) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: request)
        let sha1Response = try JSONDecoder().decode(Sha1Response.self, from: data)
        return sha1Response.sha1
    }

    func getYearDayPrayerTimes(
        year: Int
    ) async throws -> YearDayPrayerTimesRespones {
        let endpoint = PrayerTimesEndpoint.getYearDayPrayerTimes(
            year: String(format: "%04d", year)
        )
        guard let url = URL(string: endpoint.url) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(YearDayPrayerTimesRespones.self, from: data)
    }

    func getYearWeekPrayerTimes(
        year: Int
    ) async throws -> YearWeekPrayerTimesResponse {
        let endpoint = PrayerTimesEndpoint.getYearWeekPrayertimes(
            year: String(format: "%04d", year)
        )
        guard let url = URL(string: endpoint.url) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(YearWeekPrayerTimesResponse.self, from: data)
    }
}

struct Sha1Response: Decodable, Sendable {
    let sha1: String
}

public struct YearDayPrayerTimesRespones: Decodable, Sendable {
    public let year: [DayPrayerTimesResponse]
    public let sha1: String
}

public struct YearWeekPrayerTimesResponse: Decodable, Sendable {
    public let sha1: String
    public let weeks: [WeekPrayerTimes]

    public struct WeekPrayerTimes: Decodable, Sendable {
        public let id: Int
        public let mon: DayPrayertimes?
        public let tue: DayPrayertimes?
        public let wed: DayPrayertimes?
        public let thu: DayPrayertimes?
        public let fri: DayPrayertimes?
        public let sat: DayPrayertimes?
        public let sun: DayPrayertimes?
        public let hadith: Hadith?
    }

    public struct DayPrayertimes: Decodable, Sendable {
        public let id: Int
        public let gregorian: String
        public let hijri: String
        public let prayerTimes: PrayerTimesResponse
    }

    public struct Hadith: Decodable, Sendable {
        public let hadith: String
        public let note: String?
    }
}

public struct DayPrayerTimesResponse: Decodable, Sendable {
    public let id: Int
    public let weekId: Int
    public let gregorian: String
    public let hijri: String
    public let prayerTimes: PrayerTimesResponse
    public let event: DayEventResponse?
}

public struct PrayerTimesResponse: Decodable, Sendable {
    public let imsak: String?
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let ishaa: String
}

public struct DayEventResponse: Decodable, Sendable {
    public let ar: String
    public let en: String?
}

extension YearWeekPrayerTimesResponse.DayPrayertimes {
    public var intoStorage: YearWeekPrayerTimesStorage.DayPrayertimesStorage {
        YearWeekPrayerTimesStorage.DayPrayertimesStorage(
            id: id,
            gregorian: gregorian,
            hijri: hijri,
            prayerTimes: PrayerTimesStorage(
                imsak: self.prayerTimes.imsak,
                fajr: self.prayerTimes.fajr,
                sunrise: self.prayerTimes.sunrise,
                dhuhr: self.prayerTimes.dhuhr,
                asr: self.prayerTimes.asr,
                maghrib: self.prayerTimes.maghrib,
                ishaa: self.prayerTimes.ishaa
            )
        )
    }
}

extension YearWeekPrayerTimesResponse.WeekPrayerTimes {
    public var intoStorage: YearWeekPrayerTimesStorage.WeekPrayerTimesStorage {
        YearWeekPrayerTimesStorage.WeekPrayerTimesStorage(
            id: id,
            mon: mon?.intoStorage,
            tue: tue?.intoStorage,
            wed: wed?.intoStorage,
            thu: thu?.intoStorage,
            fri: fri?.intoStorage,
            sat: sat?.intoStorage,
            sun: sun?.intoStorage,
            hadith: hadith?.intoStorage
        )
    }
}

extension YearWeekPrayerTimesResponse.Hadith {
    public var intoStorage: YearWeekPrayerTimesStorage.HadithStorage {
        YearWeekPrayerTimesStorage.HadithStorage(hadith: hadith, note: note)
    }
}

extension DayPrayerTimesResponse {
    public var intoStorage: DayPrayerTimesStorage {
        DayPrayerTimesStorage(
            id: self.id,
            weekId: self.weekId,
            gregorian: self.gregorian,
            hijri: self.hijri,
            prayerTimes: PrayerTimesStorage(
                imsak: self.prayerTimes.imsak,
                fajr: self.prayerTimes.fajr,
                sunrise: self.prayerTimes.sunrise,
                dhuhr: self.prayerTimes.dhuhr,
                asr: self.prayerTimes.asr,
                maghrib: self.prayerTimes.maghrib,
                ishaa: self.prayerTimes.ishaa
            ),
            event: self.event.map { DayEventStorage(ar: $0.ar, en: $0.en) }
        )
    }
}
