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

        let currentDate = Date.now
        for minuteOffset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
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
                if let hijriDate = store.todaysPrayerTimes?.hijri {
                    Text(hijriDate)
                } else {
                    Text(verbatim: "Placeholder")
                        .redacted(reason: .placeholder)
                }
            }

            HStack {
                VStack {
                    prayerTime(
                        .fajer,
                        time: prayerTimes.fajer,
                        systemImage: "moon.stars"
                    )
                    prayerTime(
                        .sunrise,
                        time: prayerTimes.sunrise,
                        systemImage: "sunrise"
                    )
                    prayerTime(
                        .dhuhr,
                        time: prayerTimes.dhuhr,
                        systemImage: "sun.max"
                    )
                }

                Divider()

                VStack {
                    prayerTime(
                        .asr,
                        time: prayerTimes.asr,
                        systemImage: "sun.min"
                    )
                    prayerTime(
                        .maghrib,
                        time: prayerTimes.maghrib,
                        systemImage: "sunset"
                    )
                    prayerTime(
                        .ishaa,
                        time: prayerTimes.ishaa,
                        systemImage: "moon"
                    )
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
        _ prayer: Prayer,
        time: Date,
        systemImage: String
    ) -> some View {
        HStack {
            Text(prayer.localizedStringKey).font(.caption2)
            Spacer()
            Text(time, format: .dateTime.hour().minute()).font(.caption2)
        }
        .padding(2)
        .padding(.horizontal, 8)
        .if(store.currentPrayerTime == prayer) {
            $0
                .background(Capsule().fill(Color.primary))
                .foregroundStyle(.background)
        }
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
        .configurationDisplayName("Prayer Times")
        .description("View prayer times")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    PrayerTimesWidget()
} timeline: {
    SimpleEntry(date: .now)
}
