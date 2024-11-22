//
//  EditPrayerTimesView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct EditPrayerTimesView: View {
    @Bindable var store: StoreOf<EditPrayerTimesFeature>

    var body: some View {
        NavigationView {
            List {
                EditSinglePrayerTimeView(label: "Fajer", store: store.scope(
                    state: \.fajerState,
                    action: \.dependent.fajer
                ))
                EditSinglePrayerTimeView(label: "Sunrise", store: store.scope(
                    state: \.sunriseState,
                    action: \.dependent.sunrise
                ))
                EditSinglePrayerTimeView(label: "Dhuhr", store: store.scope(
                    state: \.dhuhrState,
                    action: \.dependent.dhuhr
                ))
                EditSinglePrayerTimeView(label: "Asr", store: store.scope(
                    state: \.asrState,
                    action: \.dependent.asr
                ))
                EditSinglePrayerTimeView(label: "Maghrib", store: store.scope(
                    state: \.maghribState,
                    action: \.dependent.maghrib
                ))
                EditSinglePrayerTimeView(label: "Ishaa", store: store.scope(
                    state: \.ishaaState,
                    action: \.dependent.ishaa
                ))
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
