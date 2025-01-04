//
//  PrayerTimesWidget.swift
//  PrayerTimesWidget
//
//  Created by Hamza Jadid on 02/01/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(
        in context: Context, completion: @escaping (SimpleEntry) -> ()
    ) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(
        in context: Context, completion: @escaping (Timeline<Entry>) -> ()
    ) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct PrayerTimesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        mediumContent
    }

    var mediumContent: some View {
        VStack {
            HStack {
                logo
                Spacer()
                Text("3 Rajab 1446")
                    .font(.caption2)
            }
            HStack {
                VStack {
                    prayerTime(
                        "Fajer",
                        time: entry.date,
                        systemImage: "moon.stars"
                    )
                    prayerTime("Sunrise", time: entry.date, systemImage: "sunrise")
                    prayerTime("Duhur", time: entry.date, systemImage: "sun.max")
                }
                Divider()
                VStack {
                    prayerTime("Asr", time: entry.date, systemImage: "sun.min")
                    prayerTime("Maghrib", time: entry.date, systemImage: "sunset")
                        .background(
                            Capsule().fill(Color.black)
                        )
                        .foregroundStyle(.white)
                    prayerTime("Ishaa", time: entry.date, systemImage: "moon")
                }
            }
        }
    }

    private var logo: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width / 12)
    }

    @ViewBuilder
    private func prayerTime(
        _ label: String,
        time: Date,
        systemImage: String
    ) -> some View {
        HStack {
            Text(label).font(.caption2)
            Spacer()
            Text(time, format: .dateTime.hour().minute()).font(.caption2)
        }
        .padding(2)
        .padding(.horizontal, 8)
    }
}

struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PrayerTimesWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PrayerTimesWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    PrayerTimesWidget()
} timeline: {
    SimpleEntry(date: .now)
}
