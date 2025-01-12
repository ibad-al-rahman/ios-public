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
    let hijriDay: Int
    let hijriMonth: String
    var fajer: Date
    var sunrise: Date
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var ishaa: Date
    var event: DayEvent?

    var sorted: [Date] {
        [fajer, sunrise, dhuhr, asr, maghrib, ishaa]
    }

    func getPrayer(time: Date) -> Prayer {
        return if time < fajer {
            .ishaa
        } else if time < sunrise {
            .fajer
        } else if time < dhuhr {
            .sunrise
        } else if time < asr {
            .dhuhr
        } else if time < maghrib {
            .asr
        } else if time < ishaa {
            .maghrib
        } else {
            .ishaa
        }
    }

    func getNextPrayer(time: Date) -> Prayer {
        return if time < fajer {
            .fajer
        } else if time < sunrise {
            .sunrise
        } else if time < dhuhr {
            .dhuhr
        } else if time < asr {
            .asr
        } else if time < maghrib {
            .maghrib
        } else if time < ishaa {
            .ishaa
        } else {
            .fajer
        }
    }

    func getNextPrayerTime(
        time: Date,
        tomorrowPrayerTimes: DayPrayerTimes
    ) -> Date {
        return if time < fajer {
            fajer
        } else if time < sunrise {
            sunrise
        } else if time < dhuhr {
            dhuhr
        } else if time < asr {
            asr
        } else if time < maghrib {
            maghrib
        } else if time < ishaa {
            ishaa
        } else {
            tomorrowPrayerTimes.fajer
        }
    }
}

extension DayPrayerTimes {
    init?(from model: DayPrayerTimesModel) {
        let calendar = Calendar.current
        let gregorianFormatter = DateFormatter()
        let hijriFormatter = DateFormatter()
        let timeFormatter = DateFormatter()

        gregorianFormatter.dateFormat = "dd/MM/yyyy"
        hijriFormatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        hijriFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"

        self.id = model.id

        guard let gregorian = gregorianFormatter.date(from: model.gregorian)
        else { return nil }
        self.gregorian = gregorian

        let gregorianComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: gregorian
        )
        guard let year = gregorianComponents.year,
              let month = gregorianComponents.month,
              let day = gregorianComponents.day
        else { return nil }

        guard let hijriDate = hijriFormatter.date(from: model.hijri)
        else { return nil }

        hijriFormatter.dateFormat = "d"
        guard let hijriDay = Int(hijriFormatter.string(from: hijriDate))
        else { return nil }
        self.hijriDay = hijriDay

        hijriFormatter.dateFormat = "MMMM"
        self.hijriMonth = hijriFormatter.string(from: hijriDate)

        hijriFormatter.dateFormat = "d MMMM yyyy"
        self.hijri = hijriFormatter.string(from: hijriDate)

        guard let fajer = timeFormatter.date(from: model.prayerTimes.fajer)
        else { return nil }

        var fajerComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: fajer
        )
        fajerComponents.year = year
        fajerComponents.month = month
        fajerComponents.day = day
        let fajerDate = calendar.date(from: fajerComponents)
        guard let fajerDate else { return nil }
        self.fajer = fajerDate

        guard let sunrise = timeFormatter.date(from: model.prayerTimes.sunrise)
        else { return nil }

        var sunriseComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: sunrise
        )
        sunriseComponents.year = year
        sunriseComponents.month = month
        sunriseComponents.day = day
        let sunriseDate = calendar.date(from: sunriseComponents)
        guard let sunriseDate else { return nil }
        self.sunrise = sunriseDate

        guard let dhuhr = timeFormatter.date(from: model.prayerTimes.dhuhr)
        else { return nil }

        var dhuhrComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: dhuhr
        )
        dhuhrComponents.year = year
        dhuhrComponents.month = month
        dhuhrComponents.day = day
        let dhuhrDate = calendar.date(from: dhuhrComponents)
        guard let dhuhrDate else { return nil }
        self.dhuhr = dhuhrDate

        guard let asr = timeFormatter.date(from: model.prayerTimes.asr)
        else { return nil }

        var asrComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: asr
        )
        asrComponents.year = year
        asrComponents.month = month
        asrComponents.day = day
        let asrDate = calendar.date(from: asrComponents)
        guard let asrDate else { return nil }
        self.asr = asrDate

        guard let maghrib = timeFormatter.date(from: model.prayerTimes.maghrib)
        else { return nil }

        var maghribComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: maghrib
        )
        maghribComponents.year = year
        maghribComponents.month = month
        maghribComponents.day = day
        let maghribDate = calendar.date(from: maghribComponents)
        guard let maghribDate else { return nil }
        self.maghrib = maghribDate

        guard let ishaa = timeFormatter.date(from: model.prayerTimes.ishaa)
        else { return nil }

        var ishaaComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: ishaa
        )
        ishaaComponents.year = year
        ishaaComponents.month = month
        ishaaComponents.day = day
        let ishaaDate = calendar.date(from: ishaaComponents)
        guard let ishaaDate else { return nil }
        self.ishaa = ishaaDate

        self.event = DayEvent(from: model)
    }

    static func placeholder() -> DayPrayerTimes {
        DayPrayerTimes(
            id: 0,
            gregorian: .now,
            hijri: "1/1/1444",
            hijriDay: 1,
            hijriMonth: "Muharram",
            fajer: .now,
            sunrise: .now,
            dhuhr: .now,
            asr: .now,
            maghrib: .now,
            ishaa: .now
        )
    }
}
