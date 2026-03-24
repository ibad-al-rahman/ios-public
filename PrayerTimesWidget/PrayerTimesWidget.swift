//
//  WidgetConfig.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import MiqatKit
import SwiftUI
import WidgetKit

struct PrayerTimeTimelineProvider: TimelineProvider {
    @Dependency(\.miqatService) var miqatService

    func placeholder(in context: Context) -> PrayerTimeEntry {
        PrayerTimeEntry(
            date: .now,
            currentPrayer: .maghrib,
            nextPrayer: .ishaa,
            nextPrayerDate: .now
        )
    }

    func getSnapshot(
        in context: Context, completion: @escaping (PrayerTimeEntry) -> ()
    ) {
        let prayerTimes = getPrayerTimesSequnce()
        let entry = prayerTimes.first ?? PrayerTimeEntry(
            date: .now,
            currentPrayer: .maghrib,
            nextPrayer: .ishaa,
            nextPrayerDate: .now
        )
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<PrayerTimeEntry>) -> ()
    ) {
        let timeline = Timeline(entries: getPrayerTimesSequnce(), policy: .atEnd)
        completion(timeline)
    }

    func getPrayerTimesSequnce() -> [PrayerTimeEntry] {
        let now = Date.now
        let tzOffset = TimeZone.current.secondsFromGMT()
        let todayTimestamp = now.timeIntervalSince1970 + TimeInterval(tzOffset)

        let todayData = miqatService.getMiqatData(timestampSecs: todayTimestamp, provider: .darElFatwa(.beirut))
        let prayerTimes = DayPrayerTimes(from: todayData)

        let tomorrowMidnight = Calendar.current.startOfDay(for: now.addingTimeInterval(86400))
        let tomorrowTimestamp = tomorrowMidnight.timeIntervalSince1970 + TimeInterval(tzOffset)
        let tomorrowData = miqatService.getMiqatData(timestampSecs: tomorrowTimestamp, provider: .darElFatwa(.beirut))
        let tomorrowPrayerTimes = DayPrayerTimes(from: tomorrowData)

        return [
            [PrayerTimeEntry(
                date: now,
                currentPrayer: prayerTimes.getPrayer(time: now),
                nextPrayer: prayerTimes.getNextPrayer(time: now),
                nextPrayerDate: prayerTimes.getNextPrayerTime(
                    time: now,
                    tomorrowPrayerTimes: tomorrowPrayerTimes
                )
            )],
            prayerTimes
                .sorted
                .filter { now < $0 }
                .map {
                    PrayerTimeEntry(
                        date: $0,
                        currentPrayer: prayerTimes.getPrayer(time: $0),
                        nextPrayer: prayerTimes.getNextPrayer(time: $0),
                        nextPrayerDate: prayerTimes.getNextPrayerTime(
                            time: $0,
                            tomorrowPrayerTimes: tomorrowPrayerTimes
                        )
                    )
                },
            [
                PrayerTimeEntry(
                    date: tomorrowMidnight,
                    currentPrayer: tomorrowPrayerTimes.getPrayer(time: tomorrowMidnight),
                    nextPrayer: tomorrowPrayerTimes.getNextPrayer(time: tomorrowMidnight),
                    nextPrayerDate: tomorrowPrayerTimes.getNextPrayerTime(
                        time: tomorrowMidnight,
                        tomorrowPrayerTimes: tomorrowPrayerTimes
                    )
                )
            ]
        ]
        .flatMap { $0 }
    }
}

struct PrayerTimeEntry: TimelineEntry {
    let date: Date
    let currentPrayer: Prayer
    let nextPrayer: Prayer
    let nextPrayerDate: Date
}

struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind, provider: PrayerTimeTimelineProvider()
        ) { entry in
            if #available(iOS 17.0, *) {
                PrayerTimesWidgetView(store: Store(
                    initialState: PrayerTimesWidgetFeature.State(
                        date: entry.date,
                        currentPrayer: entry.currentPrayer,
                        nextPrayer: entry.nextPrayer,
                        nextPrayerDate: entry.nextPrayerDate
                    ),
                    reducer: PrayerTimesWidgetFeature.init
                ))
                .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PrayerTimesWidgetView(store: Store(
                    initialState: PrayerTimesWidgetFeature.State(
                        date: entry.date,
                        currentPrayer: entry.currentPrayer,
                        nextPrayer: entry.nextPrayer,
                        nextPrayerDate: entry.nextPrayerDate
                    ),
                    reducer: PrayerTimesWidgetFeature.init
                ))
                .padding()
                .background()
            }
        }
        .configurationDisplayName("prayer_times")
        .description("view_prayer_times")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}

#Preview(as: .systemMedium) {
    PrayerTimesWidget()
} timeline: {
    PrayerTimeEntry(
        date: .now,
        currentPrayer: .maghrib,
        nextPrayer: .ishaa,
        nextPrayerDate: .now
    )
}
