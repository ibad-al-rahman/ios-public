//
//  DailyPrayerTimesView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import IbadRepositories
import SwiftUI

struct DailyPrayerTimesView: View {
    @Bindable var store: StoreOf<DailyPrayerTimesFeature>

    var body: some View {
        List {
            datePicker
            if let prayerTimes = store.todaysPrayerTimes {
                dayPrayerTimes(prayerTimes)
            } else {
                dayPrayerTimes(.placeholder())
                    .redacted(reason: .placeholder)
            }
            todaysEvents
                .featureFlagged(.prayerTimesEvents)
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
        } header: {
            HStack {
                Spacer()

                if store.canResetDate {
                    Button(action: { store.date = .now }) {
                        Label(
                            "Back to today",
                            systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90"
                        )
                    }
                    .textCase(nil)
                }
            }
        } footer: {
            if let hijriDate = store.todaysPrayerTimes?.hijri {
                Text(hijriDate)
            } else {
                Text(verbatim: "Placeholder")
                    .redacted(reason: .placeholder)
            }
        }
    }

    private func dayPrayerTimes(_ prayerTimes: DayPrayerTimes) -> some View {
        Section {
            Group {
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
            .foregroundStyle(.primary)
        } header: {
            HStack {
                Text("Timings")
                Spacer()
                Button(action: { store.send(.onTapShare) }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .textCase(nil)
                .featureFlagged(.prayerTimesShare)
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
        time: Date,
        systemImage: String
    ) -> some View {
        Label(prayer.localizedStringKey, systemImage: systemImage)
            .badge(Text(time, format: .dateTime.hour().minute()))
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
