//
//  DayPrayerTimes.swift
//  PublicSector
//
//  Created by Hamza Jadid on 25/08/2024.
//

import Foundation

struct DayPrayerTimes: Equatable, Identifiable {
    let id: String
    let date: Date
    var fajerTime: Date?
    var sunriseTime: Date?
    var dhuhrTime: Date?
    var asrTime: Date?
    var maghribTime: Date?
    var ishaaTime: Date?

    init(date: Date = .now) {
        self.id = UUID().uuidString
        self.date = date

        var fajerComponents = DateComponents()
        fajerComponents.hour = 4
        fajerComponents.minute = 28
        fajerTime = Calendar.current.date(from: fajerComponents)

        var sunriseComponents = DateComponents()
        sunriseComponents.hour = 6
        sunriseComponents.minute = 6
        sunriseTime = Calendar.current.date(from: sunriseComponents)

        var dhuhrComponents = DateComponents()
        dhuhrComponents.hour = 12
        dhuhrComponents.minute = 40
        dhuhrTime = Calendar.current.date(from: dhuhrComponents)

        var asrComponents = DateComponents()
        asrComponents.hour = 16
        asrComponents.minute = 20
        asrTime = Calendar.current.date(from: asrComponents)

        var maghribComponents = DateComponents()
        maghribComponents.hour = 19
        maghribComponents.minute = 18
        maghribTime = Calendar.current.date(from: maghribComponents)

        var ishaaComponents = DateComponents()
        ishaaComponents.hour = 20
        ishaaComponents.minute = 40
        ishaaTime = Calendar.current.date(from: ishaaComponents)
    }

    mutating func offset(_ offset: PrayerTimesOffset) {
        let calendar = Calendar.current
        if let fajerTime {
            self.fajerTime = calendar.date(
                byAdding: .minute, value: offset.fajer, to: fajerTime
            )
        }

        if let sunriseTime {
            self.sunriseTime = calendar.date(
                byAdding: .minute, value: offset.sunrise, to: sunriseTime
            )
        }

        if let dhuhrTime {
            self.dhuhrTime = calendar.date(
                byAdding: .minute, value: offset.dhuhr, to: dhuhrTime
            )
        }

        if let asrTime {
            self.asrTime = calendar.date(
                byAdding: .minute, value: offset.asr, to: asrTime
            )
        }

        if let maghribTime {
            self.maghribTime = calendar.date(
                byAdding: .minute, value: offset.maghrib, to: maghribTime
            )
        }

        if let ishaaTime {
            self.ishaaTime = calendar.date(
                byAdding: .minute, value: offset.ishaa, to: ishaaTime
            )
        }
    }
}
