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
            if let error = store.error {
                errorContent(error: error)
            } else {
                content
            }
        }
        .onAppear { store.send(.onAppear) }
    }

    var content: some View {
        Group {
            if let prayerTimes = store.todaysPrayerTimes {
                dayPrayerTimes(prayerTimes)
            } else {
                dayPrayerTimes(.placeholder())
                    .redacted(reason: .placeholder)
            }
            todaysEvents
        }
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

    @ViewBuilder
    private var todaysEvents: some View {
        if let event = store.event {
            Section {
                Text(event)
            } header: {
                Text("Holidays and Events")
            }
        } else {
            EmptyView()
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

    private func errorContent(error: DailyPrayerTimesFeature.Error) -> some View {
        Section {
            Group {
                HStack {
                    Text(verbatim: "⚠️")
                        .font(.title)
                    Text(error.localizedStringKey)
                }
                Button(action: { store.send(.onTapRetry) }) {
                    Text("Retry")
                }
            }
        }
    }
}

extension DailyPrayerTimesFeature.Error {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .unknown: "Something went wrong"
        case .unreachable: "We couldn’t reach the server. Please check your internet connection and try again."
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
