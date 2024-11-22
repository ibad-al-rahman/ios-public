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
            Form { }
                .navigationTitle("Edit")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
