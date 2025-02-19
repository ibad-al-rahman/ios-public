//
//  PrayerTimesService.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Alamofire
import OSLog

struct PrayerTimesService {
    let nwReachabilityManager = NetworkReachabilityManager()

    func getSha1(year: Int) async -> Result<String, ServiceError> {
        guard let nwReachabilityManager, nwReachabilityManager.isReachable
        else { return .failure(.unreachable) }

        let year = String(format: "%04d", year)
        let endpoint = PrayerTimesEndpoint.getSha1(year: year)
        let response = await AF.request(endpoint.url, interceptor: .retryPolicy)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable(Sha1Response.self)
            .response
        guard let sha1 = response.value?.sha1 else { return .failure(.unknown) }
        Logger.remote.info("Fetched prayer times sha1: \(sha1)")
        return .success(sha1)
    }

    func getYearDayPrayerTimes(
        year: Int
    ) async -> Result<YearDayPrayerTimesRespones, ServiceError> {
        guard let nwReachabilityManager, nwReachabilityManager.isReachable
        else { return .failure(.unreachable) }

        let endpoint = PrayerTimesEndpoint.getYearDayPrayerTimes(
            year: String(format: "%04d", year)
        )
        let response = await AF.request(endpoint.url, interceptor: .retryPolicy)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable(YearDayPrayerTimesRespones.self)
            .response
        guard let prayerTimes = response.value else { return .failure(.unknown) }
        Logger.remote.info("Fetched \(year) year prayer times")
        return .success(prayerTimes)
    }

    func getYearWeekPrayerTimes(
        year: Int
    ) async -> Result<YearWeekPrayerTimesResponse, ServiceError> {
        guard let nwReachabilityManager, nwReachabilityManager.isReachable
        else { return .failure(.unreachable) }

        let endpoint = PrayerTimesEndpoint.getYearWeekPrayertimes(
            year: String(format: "%04d", year)
        )
        let response = await AF.request(endpoint.url, interceptor: .retryPolicy)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable(YearWeekPrayerTimesResponse.self)
            .response
        guard let prayerTimes = response.value else { return .failure(.unknown) }
        Logger.remote.info("Fetched \(year) year week prayer times")
        return .success(prayerTimes)
    }
}

public enum ServiceError: Error {
    case unreachable
    case unknown
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
    }

    public struct DayPrayertimes: Decodable, Sendable {
        public let id: Int
        public let gregorian: String
        public let hijri: String
        public let prayerTimes: PrayerTimesResponse
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
            sun: sun?.intoStorage
        )
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
