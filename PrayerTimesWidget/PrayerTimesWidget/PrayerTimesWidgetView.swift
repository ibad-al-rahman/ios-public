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

    var body: some View {
        content
            .onAppear { store.send(.onAppear) }
            .dynamicTypeSize(.xLarge)
    }

    @ViewBuilder
    private var content: some View {
        if let prayerTimes = store.todaysPrayerTimes {
            mediumContent(prayerTimes)
        } else {
            mediumContent(.placeholder())
                .redacted(reason: .placeholder)
        }
    }

    private func mediumContent(_ prayerTimes: DayPrayerTimes) -> some View {
        VStack {
            HStack {
                logo
                Spacer()
                if let hijriDate = store.todaysPrayerTimes?.hijri {
                    Text(hijriDate)
                        .font(.caption)
                } else {
                    Text(verbatim: "Placeholder").redacted(reason: .placeholder)
                        .font(.caption)
                }
            }

            HStack {
                VStack {
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
                }

                Divider()
                    .frame(width: 1)
                    .overlay(.gray.opacity(0.8))

                VStack {
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
    }

    private var logo: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width: 32)
    }

    @ViewBuilder
    private func prayerTime(
        _ prayer: Prayer,
        time: Date,
        systemImage: String
    ) -> some View {
        HStack {
            Text(prayer.localizedStringKey).font(.caption)
            Spacer()
            Text(time, format: .dateTime.hour().minute()).font(.caption)
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
