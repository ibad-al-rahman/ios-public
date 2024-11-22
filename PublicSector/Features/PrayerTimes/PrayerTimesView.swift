//
//  PrayerTimesView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct PrayerTimesView: View {
    @Bindable var store: StoreOf<PrayerTimesFeature>

    var body: some View {
        NavigationStack {
            VStack {
                picker
                content
            }
            .navigationTitle("Prayer Times")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarItems }
            .sheet(
                item: $store.scope(
                    state: \.destination?.edit,
                    action: \.dependent.destination.edit
                ),
                content: { EditPrayerTimesView(store: $0) }
            )
        }
    }

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { store.send(.onTapEdit) }) {
                Text("Edit")
            }
        }
    }

    private var picker: some View {
        Picker(selection: $store.prayerTimesPicker) {
            ForEach(PrayerTimesFeature.PrayerTimesPicker.allCases) {
                Text($0.localizedStringKey).tag($0)
            }
        } label: {
            Text(verbatim: "Picker")
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    @ViewBuilder
    private var content: some View {
        switch store.prayerTimesPicker {
        case .daily:
            dailyPrayer

        case .weekly:
            weeklyPicker
        }
    }

    var dailyPrayer: some View {
        DailyPrayerTimesView(store: store.scope(
            state: \.dailyPrayerState,
            action: \.dependent.dailyPrayer
        ))
    }

    var weeklyPicker: some View {
        WeeklyPrayerTimesView(store: store.scope(
            state: \.weeklyPrayerState,
            action: \.dependent.weeklyPrayer
        ))
    }
}

extension PrayerTimesFeature.PrayerTimesPicker {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .daily: "Daily"
        case .weekly: "Weekly"
        }
    }
}

#Preview {
    PrayerTimesView(store: Store(
        initialState: PrayerTimesFeature.State(),
        reducer: PrayerTimesFeature.init
    ))
}

#Preview {
    PrayerTimesView(store: Store(
        initialState: PrayerTimesFeature.State(),
        reducer: PrayerTimesFeature.init
    ))
    .arabicEnvironment()
}
