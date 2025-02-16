//
//  WeeklyPrayerTimesView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct WeeklyPrayerTimesView: View {
    let store: StoreOf<WeeklyPrayerTimesFeature>

    var body: some View {
        Form {
            Section {
                ScrollView(.horizontal) {
                    Grid(horizontalSpacing: .zero, verticalSpacing: .zero) {
                        GridRow {
                            Text("Week")
                            Text(Prayer.fajr.localizedStringKey)
                            Text(Prayer.sunrise.localizedStringKey)
                            Text(Prayer.dhuhr.localizedStringKey)
                            Text(Prayer.asr.localizedStringKey)
                            Text(Prayer.maghrib.localizedStringKey)
                            Text(Prayer.ishaa.localizedStringKey)
                        }
                        .bold()
                        .padding(.small)

                        Divider()

                        GridRow {
                            Text(verbatim: "Monday")
                            Text(Date.now, format: .dateTime.hour().minute())
                            Text(Date.now, format: .dateTime.hour().minute())
                            Text(Date.now, format: .dateTime.hour().minute())
                            Text(Date.now, format: .dateTime.hour().minute())
                            Text(Date.now, format: .dateTime.hour().minute())
                            Text(Date.now, format: .dateTime.hour().minute())
                        }
                        .padding(.small)

//                        ForEach(store.week) { day in
//                            Divider()
//
//                            GridRow {
//                                Text(day.date, format: .dateTime.weekday())
//                                dateText(date: day.fajrTime)
//                                dateText(date: day.sunriseTime)
//                                dateText(date: day.dhuhrTime)
//                                dateText(date: day.asrTime)
//                                dateText(date: day.maghribTime)
//                                dateText(date: day.ishaaTime)
//                            }
//                        }
                    }
                }
                .scrollIndicators(.hidden)
            } header: {
                HStack {
                    Text("Timings")
                }
            }
        }
    }

    private func dateText(date: Date?) -> some View {
        if let date {
            Text(date, format: .dateTime.hour().minute())
        } else {
            Text(verbatim: "-")
        }
    }
}

#Preview {
    WeeklyPrayerTimesView(store: Store(
        initialState: WeeklyPrayerTimesFeature.State(),
        reducer: WeeklyPrayerTimesFeature.init
    ))
}

#Preview {
    WeeklyPrayerTimesView(store: Store(
        initialState: WeeklyPrayerTimesFeature.State(),
        reducer: WeeklyPrayerTimesFeature.init
    ))
    .arabicEnvironment()
}
