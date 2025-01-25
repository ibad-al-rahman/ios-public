//
//  PrayerTimesOffset.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

struct PrayerTimesOffset: Equatable, Codable {
    var fajr: Int
    var sunrise: Int
    var dhuhr: Int
    var asr: Int
    var maghrib: Int
    var ishaa: Int

    static let `default` = PrayerTimesOffset(
        fajr: 0,
        sunrise: 0,
        dhuhr: 0,
        asr: 0,
        maghrib: 0,
        ishaa: 0
    )

    func val(_ prayer: Prayer) -> Int {
        switch prayer {
        case .fajr: fajr
        case .sunrise: sunrise
        case .dhuhr: dhuhr
        case .asr: asr
        case .maghrib: maghrib
        case .ishaa: ishaa
        }
    }

    mutating func inc(_ prayer: Prayer) {
        switch prayer {
        case .fajr: fajr += 1
        case .sunrise: sunrise += 1
        case .dhuhr: dhuhr += 1
        case .asr: asr += 1
        case .maghrib: maghrib += 1
        case .ishaa: ishaa += 1
        }
    }

    mutating func dec(_ prayer: Prayer) {
        switch prayer {
        case .fajr: fajr -= 1
        case .sunrise: sunrise -= 1
        case .dhuhr: dhuhr -= 1
        case .asr: asr -= 1
        case .maghrib: maghrib -= 1
        case .ishaa: ishaa -= 1
        }
    }
}
