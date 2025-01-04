//
//  PrayerTimesWidgetView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import SwiftUI
import WidgetKit

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
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct PrayerTimesWidgetView: View {
    let store: StoreOf<PrayerTimesWidgetFeature>

    var body: some View {
        content.onAppear { store.send(.onAppear) }
    }

    @ViewBuilder
    private var content: some View {
        if let prayerTimes = store.todaysPrayerTimes {
            mediumContent(prayerTimes)
        } else {
            mediumContent(.placeholder())
                .redacted(reason: .placeholder)
        }
    }

    private func mediumContent(_ prayerTimes: DayPrayerTimes) -> some View {
        VStack {
            HStack {
                logo
                Spacer()
                Text("3 Rajab 1446").font(.caption2)
            }

            HStack {
                VStack {
                    prayerTime(
                        "Fajer",
                        time: store.date,
                        systemImage: "moon.stars"
                    )
                    prayerTime("Sunrise", time: store.date, systemImage: "sunrise")
                    prayerTime("Duhur", time: store.date, systemImage: "sun.max")
                }

                Divider()

                VStack {
                    prayerTime("Asr", time: store.date, systemImage: "sun.min")
                    prayerTime("Maghrib", time: store.date, systemImage: "sunset")
                        .background(Capsule().fill(Color.primary))
                        .foregroundStyle(.background)
                    prayerTime("Ishaa", time: store.date, systemImage: "moon")
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
