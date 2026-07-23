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
        .sheet(item: $store.shareImage) { shareable in
            ActivityView(activityItems: [shareable.image])
        }
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
                    shareButton
                }
            }
        } footer: {
            if let note = store.calculationNote {
                Text(note)
            }
        }
    }

    private var shareButton: some View {
        // The snapshot is built lazily inside the render closure, so tapping —
        // not every header redraw — is what triggers the (main-actor) render.
        // The reducer runs it off the current run-loop turn to keep the tap snappy.
        let week = store.week
        let note = store.calculationNote
        return Button {
            store.send(.shareTapped(render: {
                BrandedWeeklyPrayerTimesView(week: week, calculationNote: note, rounded: false).snapshot()
            }))
        } label: {
            if store.isRenderingShareImage {
                ProgressView()
            } else {
                Label("share", systemImage: "square.and.arrow.up")
            }
        }
        .disabled(store.isRenderingShareImage)
        .textCase(nil)
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
