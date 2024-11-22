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
                prayerTime(
                    .fajer,
                    time: store.todaysPrayerTime.fajerTime,
                    systemImage: "moon.stars"
                )
                prayerTime(
                    .sunrise,
                    time: store.todaysPrayerTime.sunriseTime,
                    systemImage: "sunrise"
                )
                prayerTime(
                    .dhuhr,
                    time: store.todaysPrayerTime.dhuhrTime,
                    systemImage: "sun.max"
                )
                prayerTime(
                    .asr,
                    time: store.todaysPrayerTime.asrTime,
                    systemImage: "sun.min"
                )
                prayerTime(
                    .maghrib,
                    time: store.todaysPrayerTime.maghribTime,
                    systemImage: "sunset"
                )
                prayerTime(
                    .ishaa,
                    time: store.todaysPrayerTime.ishaaTime,
                    systemImage: "moon"
                )
            }
            .foregroundStyle(.primary)
        } header: {
            HStack {
                Text("Timings")
                Spacer()
                Button(action: { store.send(.onTapShare) }) {
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
        _ prayer: Prayer,
        time: Date?,
        systemImage: String
    ) -> some View {
        if let time {
            Label(prayer.localizedStringKey, systemImage: systemImage)
                .badge(
                    Text(time, format: .dateTime.hour().minute())
                )
        } else {
            Label(prayer.localizedStringKey, systemImage: systemImage)
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
