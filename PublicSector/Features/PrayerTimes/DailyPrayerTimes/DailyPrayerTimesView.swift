//
//  DailyPrayerTimesView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct DailyPrayerTimesView: View {
    @Bindable var store: StoreOf<DailyPrayerTimesFeature>

    var body: some View {
        List {
            datePicker
            dayPrayerTime
            todaysEvents
        }
        .onAppear { store.send(.onAppear) }
    }

    private var datePicker: some View {
        Section {
            DatePicker(
                "Date",
                selection: $store.date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
        } footer: {
            if let hijriDate = store.hijriFormattedDate {
                Text(hijriDate)
            }
        }
    }

    private var dayPrayerTime: some View {
        Section {
            Group {
                prayerTime("Fajer", time: store.currentDatePrayerTimes.fajerTime, systemImage: "moon.stars")
                prayerTime("Sunrise", time: store.currentDatePrayerTimes.sunriseTime, systemImage: "sunrise")
                prayerTime("Dhuhr", time: store.currentDatePrayerTimes.dhuhrTime, systemImage: "sun.max")
                prayerTime("Asr", time: store.currentDatePrayerTimes.asrTime, systemImage: "sun.min")
                prayerTime("Maghrib", time: store.currentDatePrayerTimes.maghribTime, systemImage: "sunset")
                prayerTime("Ishaa", time: store.currentDatePrayerTimes.ishaaTime, systemImage: "moon")
            }
            .foregroundStyle(.primary)
        } header: {
            HStack {
                Text("Timings")
                Spacer()
                Button(action: {
                    store.send(.onTapShare)
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .textCase(nil)
            }
        }
    }

    private var todaysEvents: some View {
        Section {
            Text(verbatim: "The memory of the Battle of Badr")
        } header: {
            Text("Holidays and Events")
        }
    }

    @ViewBuilder
    private func prayerTime(
        _ label: LocalizedStringKey,
        time: Date?,
        systemImage: String
    ) -> some View {
        if let time {
            Label(label, systemImage: systemImage)
                .badge(
                    Text(time, format: .dateTime.hour().minute())
                )
        } else {
            Label(label, systemImage: systemImage)
                .badge(Text(verbatim: "-"))
        }
    }
}

#Preview {
    DailyPrayerTimesView(store: Store(
        initialState: DailyPrayerTimesFeature.State(),
        reducer: DailyPrayerTimesFeature.init
    ))
}

#Preview {
    DailyPrayerTimesView(store: Store(
        initialState: DailyPrayerTimesFeature.State(),
        reducer: DailyPrayerTimesFeature.init
    ))
    .arabicEnvironment()
}
