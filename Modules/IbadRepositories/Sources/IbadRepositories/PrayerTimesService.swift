//
//  PrayerTimesService.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Alamofire
import OSLog

struct PrayerTimesService {
    func getSha1(year: Int) async -> String? {
        let year = String(format: "%04d", year)
        let endpoint = PrayerTimesEndpoint.getSha1(year: year)
        let response = await AF.request(endpoint.url, interceptor: .retryPolicy)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable(Sha1Response.self)
            .response
        guard let sha1 = response.value?.sha1 else { return nil }
        Logger.remote.info("Fetched prayer times sha1: \(sha1)")
        return sha1
    }

    func getDayPrayerTimes(
        year: Int, month: Int, day: Int
    ) async -> DayPrayerTimesResponse? {
        let endpoint = PrayerTimesEndpoint.getDayPrayerTimes(
            year: String(format: "%04d", year),
            month: String(format: "%02d", month),
            day: String(format: "%02d", day)
        )
        let response = await AF.request(endpoint.url, interceptor: .retryPolicy)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable(DayPrayerTimesResponse.self)
            .response
        return response.value
    }

    func getYearPrayerTimes(year: Int) async -> [DayPrayerTimesResponse]? {
        let endpoint = PrayerTimesEndpoint.getYearPrayerTimes(
            year: String(format: "%04d", year)
        )
        let response = await AF.request(endpoint.url, interceptor: .retryPolicy)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable([DayPrayerTimesResponse].self)
            .response
        Logger.remote.info("Fetched \(year) year prayer times")
        return response.value
    }
}

struct Sha1Response: Decodable, Sendable {
    let sha1: String
}

public struct DayPrayerTimesResponse: Decodable, Sendable {
    public let id: Int
    public let gregorian: String
    public let hijri: String
    public let prayerTimes: PrayerTimesResponse
}

public struct PrayerTimesResponse: Decodable, Sendable {
    public let fajer: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let ishaa: String
}

extension DayPrayerTimesResponse {
    public var intoModel: DayPrayerTimesModel {
        DayPrayerTimesModel(
            id: self.id,
            gregorian: self.gregorian,
            hijri: self.hijri,
            prayerTimes: PrayerTimesModel(
                fajer: self.prayerTimes.fajer,
                sunrise: self.prayerTimes.sunrise,
                dhuhr: self.prayerTimes.dhuhr,
                asr: self.prayerTimes.asr,
                maghrib: self.prayerTimes.maghrib,
                ishaa: self.prayerTimes.ishaa
            )
        )
    }
}
