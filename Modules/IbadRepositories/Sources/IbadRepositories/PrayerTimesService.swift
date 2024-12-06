//
//  PrayerTimesService.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Alamofire

struct PrayerTimesService {
    func getSha1() async -> String? {
        let endpoint = PrayerTimesEndpoint.getSha1
        let response = await AF.request(endpoint.url, interceptor: .retryPolicy)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable(Sha1Response.self)
            .response
        return response.value?.sha1
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
