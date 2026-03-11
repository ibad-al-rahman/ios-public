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
                            if store.hasImsak {
                                Text(Prayer.imsak.localizedStringKey)
                            }
                            Text(Prayer.fajr.localizedStringKey)
                            Text(Prayer.sunrise.localizedStringKey)
                            Text(Prayer.dhuhr.localizedStringKey)
                            Text(Prayer.asr.localizedStringKey)
                            Text(Prayer.maghrib.localizedStringKey)
                            Text(Prayer.ishaa.localizedStringKey)
                        }
                        .bold()
                        .padding(.small)

                        ForEach(store.week) { day in
                            Divider()

                            GridRow {
                                Text(day.gregorian, format: .dateTime.weekday())
                                if store.hasImsak {
                                    dateText(date: day.imsak)
                                }
                                dateText(date: day.fajr)
                                dateText(date: day.sunrise)
                                dateText(date: day.dhuhr)
                                dateText(date: day.asr)
                                dateText(date: day.maghrib)
                                dateText(date: day.ishaa)
                            }
                            .padding(.small)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            } header: {
                HStack {
                    Text("Timings")
                }
            }
        }
        .onAppear { store.send(.onAppear) }
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
