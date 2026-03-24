//
//  AdhkarView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct AdhkarView: View {
    @Bindable var store: StoreOf<AdhkarFeature>

    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationRowView("morning_adhkar", systemName: "sun.horizon")
                    NavigationRowView("evening_adhkar", systemName: "moon.stars")
                } header: {
                    Spacer(minLength: Spacing.small)
                }
            }
            .navigationTitle("adhkar")
        }
    }
}

#Preview {
    AdhkarView(store: Store(
        initialState: AdhkarFeature.State(),
        reducer: AdhkarFeature.init
    ))
}

#Preview {
    AdhkarView(store: Store(
        initialState: AdhkarFeature.State(),
        reducer: AdhkarFeature.init
    ))
    .arabicEnvironment()
}
