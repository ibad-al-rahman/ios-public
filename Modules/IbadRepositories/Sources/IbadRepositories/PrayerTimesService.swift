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
        let endpoint = PrayerTimesEndpoint.getDailyPrayerTimes(
            year: "2024", month: "12", day: "01"
        )
        let response = await AF.request(endpoint.url, interceptor: .retryPolicy)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable(DayPrayerTimesResponse.self)
            .response
        return response.value
    }
}

struct DayPrayerTimesResponse: Decodable {
    let hijri: String
    let prayerTimes: PrayerTimesResponse
}

struct PrayerTimesResponse: Decodable {
    let fajer: String
    let sunrise: String
}
