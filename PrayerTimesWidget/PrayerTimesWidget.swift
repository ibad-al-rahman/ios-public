//
//  WidgetConfig.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import IbadRepositories
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    @Dependency(\.prayerTimesLocalRepo) private var prayerTimesLocalRepo

    func placeholder(in context: Context) -> PrayerTimeEntry {
        PrayerTimeEntry(date: .now, currentPrayer: .maghrib)
    }

    func getSnapshot(
        in context: Context, completion: @escaping (PrayerTimeEntry) -> ()
    ) {
        let date = Date.now
        let components = Calendar.current.dateComponents(
            [.year, .month, .day], from: date
        )
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let dayPrayerTimes = prayerTimesLocalRepo.getDayPrayerTimes(
                year: year, month: month, day: day
              ),
              let prayerTimes = DayPrayerTimes(from: dayPrayerTimes)
        else {
            completion(PrayerTimeEntry(date: .now, currentPrayer: .maghrib))
            return
        }
        let entry = PrayerTimeEntry(
            date: date,currentPrayer: prayerTimes.getPrayer(time: date)
        )
        completion(entry)
    }

    func getTimeline(
        in context: Context, completion: @escaping (Timeline<Entry>) -> ()
    ) {
        let currentDate = Date.now
        let components = Calendar.current.dateComponents(
            [.year, .month, .day], from: currentDate
        )
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let dayPrayerTimes = prayerTimesLocalRepo.getDayPrayerTimes(
                year: year, month: month, day: day
              ),
              let prayerTimes = DayPrayerTimes(from: dayPrayerTimes)
        else { return }

        var upcomingPrayers = prayerTimes
            .sorted
            .filter { currentDate < $0 }
            .map {
                PrayerTimeEntry(
                    date: $0,
                    currentPrayer: prayerTimes.getPrayer(time: $0)
                )
            }
        let now = Date.now
        upcomingPrayers.insert(PrayerTimeEntry(
            date: now, currentPrayer: prayerTimes.getPrayer(time: now)
        ), at: 0)

        let secondsPerDay = 60 * 60 * 24.0
        let tomorrowMidnight = Calendar.current.startOfDay(
            for: .now.addingTimeInterval(secondsPerDay)
        )
        let tomorrowComponents = Calendar.current.dateComponents(
            [.year, .month, .day], from: tomorrowMidnight
        )
        guard let tomorrowYear = tomorrowComponents.year,
              let tomorrowMonth = tomorrowComponents.month,
              let tomorrowDay = tomorrowComponents.day,
              let dayPrayerTimes = prayerTimesLocalRepo.getDayPrayerTimes(
                year: tomorrowYear, month: tomorrowMonth, day: tomorrowDay
              ),
              let tomorrowPrayerTimes = DayPrayerTimes(from: dayPrayerTimes)
        else { return }
        upcomingPrayers.append(PrayerTimeEntry(
            date: tomorrowMidnight,
            currentPrayer: tomorrowPrayerTimes.getPrayer(time: tomorrowMidnight)
        ))

        let timeline = Timeline(entries: upcomingPrayers, policy: .atEnd)
        completion(timeline)
    }
}

struct PrayerTimeEntry: TimelineEntry {
    let date: Date
    let currentPrayer: Prayer
}

struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PrayerTimesWidgetView(store: Store(
                    initialState: PrayerTimesWidgetFeature.State(
                        date: entry.date, currentPrayer: entry.currentPrayer
                    ),
                    reducer: PrayerTimesWidgetFeature.init
                ))
                .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PrayerTimesWidgetView(store: Store(
                    initialState: PrayerTimesWidgetFeature.State(
                        date: entry.date, currentPrayer: entry.currentPrayer
                    ),
                    reducer: PrayerTimesWidgetFeature.init
                ))
                .padding()
                .background()
            }
        }
        .configurationDisplayName("Prayer Times")
        .description("View prayer times")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    PrayerTimesWidget()
} timeline: {
    PrayerTimeEntry(date: .now, currentPrayer: .maghrib)
}
