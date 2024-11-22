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
                    Grid {
                        GridRow {
                            Text("Week")
                            Text(Prayer.fajer.localizedStringKey)
                            Text(Prayer.sunrise.localizedStringKey)
                            Text(Prayer.dhuhr.localizedStringKey)
                            Text(Prayer.asr.localizedStringKey)
                            Text(Prayer.maghrib.localizedStringKey)
                            Text(Prayer.ishaa.localizedStringKey)
                        }
                        .bold()

                        ForEach(store.week) { day in
                            Divider()

                            GridRow {
                                Text(day.date, format: .dateTime.weekday())
                                dateText(date: day.fajerTime)
                                dateText(date: day.sunriseTime)
                                dateText(date: day.dhuhrTime)
                                dateText(date: day.asrTime)
                                dateText(date: day.maghribTime)
                                dateText(date: day.ishaaTime)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            } header: {
                HStack {
                    Text("Timings")
                    Spacer()
                    Button(action: {}) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .textCase(nil)
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
