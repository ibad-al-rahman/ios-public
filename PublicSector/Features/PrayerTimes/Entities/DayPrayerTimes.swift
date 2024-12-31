//
//  DayPrayerTimes.swift
//  PublicSector
//
//  Created by Hamza Jadid on 25/08/2024.
//

import IbadRepositories
import Foundation

struct DayPrayerTimes: Equatable, Identifiable {
    let id: Int
    let gregorian: Date
    let hijri: String
    var fajer: Date
    var sunrise: Date
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var ishaa: Date
    var event: DayEvent?

    mutating func offset(_ offset: PrayerTimesOffset) {
        let calendar = Calendar.current
        self.fajer = calendar.date(
            byAdding: .minute, value: offset.fajer, to: fajer
        )!

        self.sunrise = calendar.date(
            byAdding: .minute, value: offset.sunrise, to: sunrise
        )!

        self.dhuhr = calendar.date(
            byAdding: .minute, value: offset.dhuhr, to: dhuhr
        )!

        self.asr = calendar.date(
            byAdding: .minute, value: offset.asr, to: asr
        )!

        self.maghrib = calendar.date(
            byAdding: .minute, value: offset.maghrib, to: maghrib
        )!

        self.ishaa = calendar.date(
            byAdding: .minute, value: offset.ishaa, to: ishaa
        )!
    }
}

extension DayPrayerTimes {
    init?(from response: DayPrayerTimesResponse) {
        let gregorianFormatter = DateFormatter()
        let hijriFormatter = DateFormatter()
        let timeFormatter = DateFormatter()

        gregorianFormatter.dateFormat = "dd/mm/yyyy"
        hijriFormatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        hijriFormatter.dateFormat = "dd/mm/yyyy"
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"

        self.id = response.id

        guard let gregorian = gregorianFormatter.date(from: response.gregorian)
        else { return nil }
        self.gregorian = gregorian

        guard let hijriDate = hijriFormatter.date(from: response.hijri)
        else { return nil }
        hijriFormatter.dateFormat = "d MMMM yyyy"
        let hijri = hijriFormatter.string(from: hijriDate)
        self.hijri = hijri

        guard let fajer = timeFormatter.date(from: response.prayerTimes.fajer)
        else { return nil }
        self.fajer = fajer

        guard let sunrise = timeFormatter.date(from: response.prayerTimes.sunrise)
        else { return nil }
        self.sunrise = sunrise

        guard let dhuhr = timeFormatter.date(from: response.prayerTimes.dhuhr)
        else { return nil }
        self.dhuhr = dhuhr

        guard let asr = timeFormatter.date(from: response.prayerTimes.asr)
        else { return nil }
        self.asr = asr

        guard let maghrib = timeFormatter.date(from: response.prayerTimes.maghrib)
        else { return nil }
        self.maghrib = maghrib

        guard let ishaa = timeFormatter.date(from: response.prayerTimes.ishaa)
        else { return nil }
        self.ishaa = ishaa

        self.event = DayEvent(from: response)
    }

    init?(from response: DayPrayerTimesModel) {
        let gregorianFormatter = DateFormatter()
        let hijriFormatter = DateFormatter()
        let timeFormatter = DateFormatter()

        gregorianFormatter.dateFormat = "dd/mm/yyyy"
        hijriFormatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        hijriFormatter.dateFormat = "dd/mm/yyyy"
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"

        self.id = response.id

        guard let gregorian = gregorianFormatter.date(from: response.gregorian)
        else { return nil }
        self.gregorian = gregorian

        guard let hijriDate = hijriFormatter.date(from: response.hijri)
        else { return nil }
        hijriFormatter.dateFormat = "d MMMM yyyy"
        let hijri = hijriFormatter.string(from: hijriDate)
        self.hijri = hijri

        guard let fajer = timeFormatter.date(from: response.prayerTimes.fajer)
        else { return nil }
        self.fajer = fajer

        guard let sunrise = timeFormatter.date(from: response.prayerTimes.sunrise)
        else { return nil }
        self.sunrise = sunrise

        guard let dhuhr = timeFormatter.date(from: response.prayerTimes.dhuhr)
        else { return nil }
        self.dhuhr = dhuhr

        guard let asr = timeFormatter.date(from: response.prayerTimes.asr)
        else { return nil }
        self.asr = asr

        guard let maghrib = timeFormatter.date(from: response.prayerTimes.maghrib)
        else { return nil }
        self.maghrib = maghrib

        guard let ishaa = timeFormatter.date(from: response.prayerTimes.ishaa)
        else { return nil }
        self.ishaa = ishaa

        self.event = DayEvent(from: response)
    }

    static func placeholder() -> DayPrayerTimes {
        DayPrayerTimes(
            id: 0,
            gregorian: .now,
            hijri: "1/1/1444",
            fajer: .now,
            sunrise: .now,
            dhuhr: .now,
            asr: .now,
            maghrib: .now,
            ishaa: .now
        )
    }
}
