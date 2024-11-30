//
//  DailyPrayerTimesResponse.swift
//  Repositories
//
//  Created by Hamza Jadid on 01/12/2024.
//

public struct DailyPrayerTimesResponse: Codable {
    public let hijri: String
    public let prayerTimes: PrayerTimesResponse
}

public struct PrayerTimesResponse: Codable {
    public let fajer: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let ishaa: String
}
