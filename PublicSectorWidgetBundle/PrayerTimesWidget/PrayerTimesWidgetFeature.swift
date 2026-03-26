//
//  PrayerTimesWidgetFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import Foundation
import MiqatKit

@Reducer
struct PrayerTimesWidgetFeature {
    @ObservableState
    struct State: Equatable {
        let prayerTimes: DayPrayerTimes
        let currentPrayer: Prayer
        let upcomingPrayer: Prayer
        let upcomingPrayerDate: Date

        init(date: Date) {
            @Dependency(\.miqatService) var miqatService
            let tzOffset = TimeZone.current.secondsFromGMT()
            let timestamp = date.timeIntervalSince1970 + TimeInterval(tzOffset)

            let data = miqatService.getMiqatData(timestampSecs: timestamp, provider: .darElFatwa(.beirut))
            let prayerTimes = DayPrayerTimes(from: data)
            self.prayerTimes = prayerTimes

            let tomorrowDate = Calendar.current.startOfDay(for: date.addingTimeInterval(86400))
            let tomorrowTimestamp = tomorrowDate.timeIntervalSince1970 + TimeInterval(tzOffset)
            let tomorrowData = miqatService.getMiqatData(timestampSecs: tomorrowTimestamp, provider: .darElFatwa(.beirut))
            let tomorrowPrayerTimes = DayPrayerTimes(from: tomorrowData)

            if date < prayerTimes.fajr {
                self.currentPrayer = .ishaa
                self.upcomingPrayer = .fajr
                self.upcomingPrayerDate = prayerTimes.fajr
            } else if date < prayerTimes.sunrise {
                self.currentPrayer = .fajr
                self.upcomingPrayer = .sunrise
                self.upcomingPrayerDate = prayerTimes.sunrise
            } else if date < prayerTimes.dhuhr {
                self.currentPrayer = .sunrise
                self.upcomingPrayer = .dhuhr
                self.upcomingPrayerDate = prayerTimes.dhuhr
            } else if date < prayerTimes.asr {
                self.currentPrayer = .dhuhr
                self.upcomingPrayer = .asr
                self.upcomingPrayerDate = prayerTimes.asr
            } else if date < prayerTimes.maghrib {
                self.currentPrayer = .asr
                self.upcomingPrayer = .maghrib
                self.upcomingPrayerDate = prayerTimes.maghrib
            } else if date < prayerTimes.ishaa {
                self.currentPrayer = .maghrib
                self.upcomingPrayer = .ishaa
                self.upcomingPrayerDate = prayerTimes.ishaa
            } else {
                self.currentPrayer = .fajr
                self.upcomingPrayer = .fajr
                self.upcomingPrayerDate = tomorrowPrayerTimes.fajr
            }
        }
    }

    enum Action { }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
