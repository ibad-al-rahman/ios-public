//
//  PrayerTimesWidget.swift
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
        PrayerTimeEntry(date: .now)
    }

    func getSnapshot(
        in context: Context, completion: @escaping (PrayerTimeEntry) -> ()
    ) {
        completion(PrayerTimeEntry(date: .now))
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

        return [
            [PrayerTimeEntry(date: now)],
            prayerTimes.sorted.filter { now < $0 }.map(PrayerTimeEntry.init),
            [PrayerTimeEntry(date: tomorrowMidnight)]
        ]
        .flatMap { $0 }
    }
}

struct PrayerTimeEntry: TimelineEntry {
    let date: Date
}

struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind, provider: PrayerTimeTimelineProvider()
        ) { entry in
            if #available(iOS 17.0, *) {
                PrayerTimesWidgetView(store: Store(
                    initialState: PrayerTimesWidgetFeature.State(date: entry.date),
                    reducer: PrayerTimesWidgetFeature.init
                ))
                .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PrayerTimesWidgetView(store: Store(
                    initialState: PrayerTimesWidgetFeature.State(date: entry.date),
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
    PrayerTimeEntry(date: .now)
}
