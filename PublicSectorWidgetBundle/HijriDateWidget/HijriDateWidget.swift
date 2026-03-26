//
//  HijriDateWidget.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import MiqatKit
import SwiftUI
import WidgetKit

struct HijriDateTimelineProvider: TimelineProvider {
    @Dependency(\.miqatService) var miqatService

    func placeholder(in context: Context) -> HijriDateEntry {
        HijriDateEntry(date: .now)
    }

    func getSnapshot(
        in context: Context, completion: @escaping (HijriDateEntry) -> ()
    ) {
        completion(HijriDateEntry(date: .now))
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<HijriDateEntry>) -> ()
    ) {
        let timeline = Timeline(entries: getPrayerTimesSequnce(), policy: .atEnd)
        completion(timeline)
    }

    func getPrayerTimesSequnce() -> [HijriDateEntry] {
        let now = Date.now
        let tzOffset = TimeZone.current.secondsFromGMT()
        let todayTimestamp = now.timeIntervalSince1970 + TimeInterval(tzOffset)

        let todayData = miqatService.getMiqatData(timestampSecs: todayTimestamp, provider: .darElFatwa(.beirut))
        let prayerTimes = DayPrayerTimes(from: todayData)

        let tomorrowMidnight = Calendar.current.startOfDay(for: now.addingTimeInterval(86400))

        return [
            [HijriDateEntry(date: now)],
            prayerTimes.sorted.filter { now < $0 }.map(HijriDateEntry.init),
            [HijriDateEntry(date: tomorrowMidnight)]
        ]
        .flatMap { $0 }
    }
}

struct HijriDateEntry: TimelineEntry {
    let date: Date
}

struct HijriDateWidget: Widget {
    let kind: String = "HijriDateWidgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind, provider: HijriDateTimelineProvider()
        ) { entry in
            if #available(iOS 17.0, *) {
                HijriDateWidgetView(store: Store(
                    initialState: WidgetFeature.State(date: entry.date),
                    reducer: WidgetFeature.init
                ))
                .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HijriDateWidgetView(store: Store(
                    initialState: WidgetFeature.State(date: entry.date),
                    reducer: WidgetFeature.init
                ))
                .padding()
                .background()
            }
        }
        .configurationDisplayName("prayer_times")
        .description("view_prayer_times")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    HijriDateWidget()
} timeline: {
    HijriDateEntry(date: .now)
}
