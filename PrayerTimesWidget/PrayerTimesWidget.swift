//
//  WidgetConfig.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import IbadPrayerTimesRepository
import SwiftUI
import WidgetKit

struct PrayerTimeTimelineProvider: TimelineProvider {
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
        Task {
            let prayerTimes = await getPrayerTimesSequnce()
            let entry = prayerTimes.first ?? PrayerTimeEntry(
                date: .now,
                currentPrayer: .maghrib,
                nextPrayer: .ishaa,
                nextPrayerDate: .now
            )
            completion(entry)
        }
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<PrayerTimeEntry>) -> ()
    ) {
        Task {
            let timeline = Timeline(entries: await getPrayerTimesSequnce(), policy: .atEnd)
            completion(timeline)
        }
    }

    func getPrayerTimesSequnce() async -> [PrayerTimeEntry] {
        @Dependency(\.ibadPrayerTimesRepositoryLite) var repository

        guard let prayerTimes = try? await repository.getPrayerTimes(.today)
        else { return [] }

        let secondsPerDay = 60 * 60 * 24.0
        let tomorrowMidnight = Calendar.current.startOfDay(
            for: .now.addingTimeInterval(secondsPerDay)
        )

        guard let tomorrowPrayerTimes = try? await repository.getPrayerTimes(.tomorrow)
        else { return [] }

        let now = Date.now
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
        .configurationDisplayName("Prayer Times")
        .description("View prayer times")
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
