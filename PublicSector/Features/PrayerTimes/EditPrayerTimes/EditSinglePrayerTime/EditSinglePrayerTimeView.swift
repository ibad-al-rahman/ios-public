//
//  EditSinglePrayerTimeView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct EditSinglePrayerTimeView: View {
    var label: LocalizedStringKey
    @Bindable var store: StoreOf<EditSinglePrayerTimeFeature>

    var body: some View {
        Section(label) {
            HStack {
                Button(action: { store.send(.onTapDec) }) {
                    Text(verbatim: "-")
                }
                .buttonStyle(.plain)
                Spacer()
                Text("\(store.offset)")
                Spacer()
                Button(action: { store.send(.onTapInc) }) {
                    Text(verbatim: "+")
                }
                .buttonStyle(.plain)
            }
        }
    }
}
