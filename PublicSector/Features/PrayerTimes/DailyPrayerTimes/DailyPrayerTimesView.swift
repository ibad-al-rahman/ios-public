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
    @Environment(\.scenePhase) var scenePhase
    @Bindable var store: StoreOf<DailyPrayerTimesFeature>

    var body: some View {
        List {
            datePicker
            content
        }
        .onAppear { store.send(.onAppear) }
        .onChange(of: scenePhase) { (oldPhase, newPhase) in
            if newPhase == .active {
                store.send(.onAppear)
            }
        }
    }

    var content: some View {
        Group {
            dayPrayerTimes(store.dayInfo)
//            todaysEvents
//            weeklyHadith
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
            Text(store.dayInfo.hijri)
        }
    }

    private func dayPrayerTimes(_ dayInfo: DayInfo) -> some View {
        Section {
            Group {
                if let imsak = dayInfo.imsak {
                    prayerTime(
                        .imsak,
                        time: imsak,
                        systemImage: "moon.zzz"
                    )
                }
                prayerTime(
                    .fajr,
                    time: dayInfo.fajr,
                    systemImage: "moon.stars"
                )
                prayerTime(
                    .sunrise,
                    time: dayInfo.sunrise,
                    systemImage: "sunrise"
                )
                prayerTime(
                    .dhuhr,
                    time: dayInfo.dhuhr,
                    systemImage: "sun.max"
                )
                prayerTime(
                    .asr,
                    time: dayInfo.asr,
                    systemImage: "sun.min"
                )
                prayerTime(
                    .maghrib,
                    time: dayInfo.maghrib,
                    systemImage: "sunset"
                )
                prayerTime(
                    .ishaa,
                    time: dayInfo.ishaa,
                    systemImage: "moon"
                )
            }
            .foregroundStyle(.primary)
        } header: {
            HStack {
                Text("Timings")
                Spacer()
                ShareLink(item: store.shareableText) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .textCase(nil)
            }
        }
    }

//    @ViewBuilder
//    private var todaysEvents: some View {
//        if let event = store.event {
//            Section {
//                Text(event)
//            } header: {
//                Text("Holidays and Events")
//            }
//        } else {
//            EmptyView()
//        }
//    }

//    @ViewBuilder
//    private var weeklyHadith: some View {
//        if let hadith = store.weeklyHadith {
//            Section {
//                Text(verbatim: hadith.hadith)
//                    .environment(\.layoutDirection, .rightToLeft)
//            } header: {
//                Text("Hadith of the Week")
//            } footer: {
//                if let hadithNote = hadith.note {
//                    Text(verbatim: hadithNote)
//                        .environment(\.layoutDirection, .rightToLeft)
//                }
//            }
//        }
//    }

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
