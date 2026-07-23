//
//  AsrMethodView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 23/07/2026.
//

import ComposableArchitecture
import MiqatKit
import SwiftUI

struct AsrMethodView: View {
    @Bindable var store: StoreOf<AsrMethodFeature>

    var body: some View {
        Form {
            if let preview = store.preview {
                Section("preview") {
                    PrayerTimePreviewRow(prayer: .asr, time: preview.asr)
                }
            }

            Picker(selection: $store.mazhab) {
                ForEach(Miqat.Mazhab.allCases, id: \.self) {
                    Text($0.string).tag($0)
                }
            } label: {
                Spacer(minLength: Spacing.small)
            }
            .pickerStyle(.inline)
        }
        .navigationTitle("asr_method")
        .onAppear { store.send(.view(.onAppear)) }
    }
}

extension Miqat.Mazhab: @retroactive CaseIterable {
    public static var allCases: [Miqat.Mazhab] { [.shafi, .hanafi] }

    var string: String {
        switch self {
        case .shafi: String(localized: "madhab_shafi")
        case .hanafi: String(localized: "madhab_hanafi")
        }
    }
}

#Preview {
    NavigationStack {
        AsrMethodView(store: Store(
            initialState: AsrMethodFeature.State(),
            reducer: AsrMethodFeature.init
        ))
    }
}
