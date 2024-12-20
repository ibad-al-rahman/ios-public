//
//  PrayerTimesEndpoint.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Alamofire
import Foundation

enum PrayerTimesEndpoint: EndpointProtocol {
    case getSha1(year: String)
    case getDayPrayerTimes(year: String, month: String, day: String)
    case getYearPrayerTimes(year: String)

    var baseUrl: String { "https://ibad-al-rahman.github.io/prayer-times/v1" }

    var path: String {
        switch self {
        case .getSha1(let year):
            "/sha1/\(year).json"

        case let .getDayPrayerTimes(year, month, day):
            "/day/\(year)/\(month)/\(day).json"

        case .getYearPrayerTimes(let year):
            "/year/\(year).json"
        }
    }

    var queryItems: [URLQueryItem] { [] }

    var method: HTTPMethod {
        switch self {
        case .getSha1, .getDayPrayerTimes, .getYearPrayerTimes:
            .get
        }
    }
}
