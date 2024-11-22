//
//  EditSinglePrayerTimeView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct EditSinglePrayerTimeView: View {
    @Bindable var store: StoreOf<EditSinglePrayerTimeFeature>

    var body: some View {
        Section(store.prayer.localizedStringKey) {
            HStack {
                Button(action: { store.send(.onTapDec) }) {
                    Text(verbatim: "-")
                }
                .buttonStyle(.plain)
                Spacer()
                Text("\(store.prayerOffset)")
                Spacer()
                Button(action: { store.send(.onTapInc) }) {
                    Text(verbatim: "+")
                }
                .buttonStyle(.plain)
            }
        }
    }
}
