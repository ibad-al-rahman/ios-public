//
//  PrayerTimesEndpoint.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Alamofire
import Foundation

enum PrayerTimesEndpoint: EndpointProtocol {
    case getDailyPrayerTimes(year: String, month: String, day: String)

    var baseUrl: String { "https://ibad-al-rahman.github.io/prayer-times/v1" }

    var path: String {
        switch self {
        case let .getDailyPrayerTimes(year, month, day):
            "/day/\(year)/\(month)/\(day).json"
        }
    }

    var queryItems: [URLQueryItem] { [] }

    var method: HTTPMethod {
        switch self {
        case .getDailyPrayerTimes: .get
        }
    }
}
