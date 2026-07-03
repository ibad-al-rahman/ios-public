//
//  WeeklyPrayerTimesView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct WeeklyPrayerTimesView: View {
    @Bindable var store: StoreOf<WeeklyPrayerTimesFeature>

    var body: some View {
        List {
            datePicker
            weekPrayerTimes
        }
        .onAppear { store.send(.onAppear) }
    }

    private var datePicker: some View {
        Section {
            DatePicker(
                "date",
                selection: $store.date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            /* A hack to force closing the date picker on picking a date */
            .id(store.date.timeIntervalSince1970)
        }
    }

    private var weekPrayerTimes: some View {
        Section {
            if !store.week.isEmpty {
                HStack(spacing: 0) {
                    // Pinned days column — stays put while the rest scrolls.
                    BrandedWeeklyPrayerTimesView(week: store.week, mode: .pinnedDaysColumn)
                    ScrollView(.horizontal) {
                        BrandedWeeklyPrayerTimesView(week: store.week, mode: .body)
                    }
                    .scrollIndicators(.hidden)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        } header: {
            HStack {
                Text("timings")
                Spacer()
                if !store.week.isEmpty {
                    let image = BrandedWeeklyPrayerTimesView(week: store.week).snapshot()
                    ShareLink(
                        item: ShareableImage(image: image),
                        preview: SharePreview("Image", image: Image(uiImage: image))
                    ) {
                        Label("share", systemImage: "square.and.arrow.up")
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
