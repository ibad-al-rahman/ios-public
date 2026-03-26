//
//  PrayerTimesWidgetView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/01/2025.
//

import ComposableArchitecture
import SwiftUI
import WidgetKit

struct PrayerTimesWidgetView: View {
    let store: StoreOf<PrayerTimesWidgetFeature>
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        content
            .dynamicTypeSize(.large)
    }

    @ViewBuilder
    private var content: some View {
        switch widgetFamily {
        case .systemSmall:
            smallContent

        case .systemMedium:
            mediumContent

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
                        Text(store.prayerTimes.hijriDay)
                        Text(store.prayerTimes.hijriMonth)
                        Text(store.prayerTimes.hijriYear)
                    }

                    Spacer()

                    VStack {
                        Text(store.prayerTimes.gregorianDay)
                        Text(store.prayerTimes.gregorianMonth)
                        Text(store.prayerTimes.gregorianYear)
                    }
                }
                .font(.caption)
                .bold()

                Spacer()

                HStack(spacing: 0) {
                    Text(store.upcomingPrayer.localizedStringKey)
                        .bold()
                    Text(verbatim: " ")
                    Text("after_label")
                }

                Text(store.upcomingPrayerDate, style: .timer)
                    .bold()
                    .monospacedDigit()
            }
        }
    }

    private var mediumContent: some View {
        HStack {
            smallContent

            Divider()

            VStack(alignment: .leading, spacing: 0) {
                prayerTime(.fajr, time: store.prayerTimes.fajr)
                prayerTime(.sunrise, time: store.prayerTimes.sunrise)
                prayerTime(.dhuhr, time: store.prayerTimes.dhuhr)
                prayerTime(.asr, time: store.prayerTimes.asr)
                prayerTime(.maghrib, time: store.prayerTimes.maghrib)
                prayerTime(.ishaa, time: store.prayerTimes.ishaa)
            }
        }
    }

    private var accessoryRectangularContent: some View {
        HStack {
            Image(systemName: store.upcomingPrayer.symbol)
            Spacer()
            VStack(alignment: .leading) {
                Text(store.upcomingPrayer.localizedStringKey)
                    .bold()
                Text(
                    store.upcomingPrayerDate,
                    format: .dateTime.hour().minute()
                )
                .bold()
                HStack(spacing: 0) {
                    Text("after_label_capitalized")
                    Text(verbatim: " ")
                    Text(store.upcomingPrayerDate, style: .timer)
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
    private func prayerTime(_ prayer: Prayer, time: Date) -> some View {
        HStack {
            Text(prayer.localizedStringKey).font(.caption2)
            Spacer()
            Text(time, format: .dateTime.hour().minute()).font(.caption2)
        }
        .padding(2)
        .padding(.horizontal, 8)
        .if(store.currentPrayer == prayer) {
            $0
                .background(Capsule().fill(.accent))
                .foregroundStyle(.background)
                .bold()
        }
    }
}
