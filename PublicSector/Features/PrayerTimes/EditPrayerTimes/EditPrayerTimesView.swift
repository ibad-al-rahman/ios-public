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
                EditSinglePrayerTimeView(store: store.scope(
                    state: \.fajerState,
                    action: \.dependent.fajer
                ))
                EditSinglePrayerTimeView(store: store.scope(
                    state: \.sunriseState,
                    action: \.dependent.sunrise
                ))
                EditSinglePrayerTimeView(store: store.scope(
                    state: \.dhuhrState,
                    action: \.dependent.dhuhr
                ))
                EditSinglePrayerTimeView(store: store.scope(
                    state: \.asrState,
                    action: \.dependent.asr
                ))
                EditSinglePrayerTimeView(store: store.scope(
                    state: \.maghribState,
                    action: \.dependent.maghrib
                ))
                EditSinglePrayerTimeView(store: store.scope(
                    state: \.ishaaState,
                    action: \.dependent.ishaa
                ))
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
