//
//  PrayerTimesService.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Alamofire

struct PrayerTimesService {
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

public struct DayPrayerTimesResponse: Decodable, Sendable {
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
