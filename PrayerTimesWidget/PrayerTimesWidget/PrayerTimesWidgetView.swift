//
//  PrayerTimesWidgetView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import IbadRepositories
import SwiftUI
import WidgetKit

struct PrayerTimesWidgetView: View {
    let store: StoreOf<PrayerTimesWidgetFeature>
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        content
            .onAppear { store.send(.onAppear) }
            .dynamicTypeSize(.large)
    }

    @ViewBuilder
    private var content: some View {
        switch widgetFamily {
        case .systemSmall:
            smallContent

        case .systemMedium:
            if let prayerTimes = store.todaysPrayerTimes {
                mediumContent(prayerTimes)
            } else {
                mediumContent(.placeholder())
                    .redacted(reason: .placeholder)
            }

        case .accessoryRectangular:
            accessoryRectangularContent

        default:
            EmptyView()
        }
    }

    private var smallContent: some View {
        ZStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .opacity(0.15)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    VStack {
                        if let hijriDay = store.todaysPrayerTimes?.hijriDay,
                           let hijriMonth = store.todaysPrayerTimes?.hijriMonth,
                           let hijriYear = store.todaysPrayerTimes?.hijriYear,
                           let gregorianDay = store.todaysPrayerTimes?.gregorianDay,
                           let gregorianMonth = store.todaysPrayerTimes?.gregorianMonth,
                           let gregorianYear = store.todaysPrayerTimes?.gregorianYear {
                            HStack {
                                VStack {
                                    Text(hijriDay)
                                    Text(hijriMonth)
                                    Text(hijriYear)
                                }

                                Spacer()

                                VStack {
                                    Text(gregorianDay)
                                    Text(gregorianMonth)
                                    Text(gregorianYear)
                                }
                            }
                            .font(.caption)
                            .bold()

                        } else {
                            Text(verbatim: "18")
                                .redacted(reason: .placeholder)
                                .font(.caption)

                            Text(verbatim: "Placeholder")
                                .redacted(reason: .placeholder)
                                .font(.caption)
                        }
                    }
                }
                Spacer()
                HStack(spacing: 0) {
                    Text(store.nextPrayer.localizedStringKey)
                        .bold()
                    Text(verbatim: " ")
                    Text("after:")
                }
                Text(store.nextPrayerDate, style: .timer)
                    .bold()
                    .monospacedDigit()
            }
        }
    }

    private func mediumContent(_ prayerTimes: DayPrayerTimes) -> some View {
        HStack {
            smallContent

            Divider()

            VStack(alignment: .leading, spacing: 0) {
                prayerTime(
                    .fajr,
                    time: prayerTimes.fajr,
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
        }
    }

    private var accessoryRectangularContent: some View {
        HStack {
            Image(systemName: store.nextPrayer.symbol)
            Spacer()
            VStack(alignment: .leading) {
                Text(store.nextPrayer.localizedStringKey)
                    .bold()
                Text(
                    store.nextPrayerDate,
                    format: .dateTime.hour().minute()
                )
                .bold()
                HStack(spacing: 0) {
                    Text("After:")
                    Text(verbatim: " ")
                    Text(store.nextPrayerDate, style: .timer)
                        .monospacedDigit()
                }
            }
        }
    }

    private var logo: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width: 52)
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
        .if(store.currentPrayer == prayer) {
            $0
                .background(Capsule().fill(Color.primary))
                .foregroundStyle(.background)
                .bold()
        }
    }
}
