//
//  PrayerTimesCalculationMethodView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 26/03/2026.
//

import ComposableArchitecture
import MiqatKit
import SwiftUI

struct PrayerTimesCalculationMethodView: View {
    @Bindable var store: StoreOf<PrayerTimesCalculationMethodFeature>

    var body: some View {
        Form {
            Picker(selection: $store.calculationMethod) {
                ForEach(PrayerTimesCalculationMethodFeature.CalculationMethod.allCases) {
                    Text($0.string).tag($0)
                }
            } label: {
                Spacer(minLength: Spacing.small)
            }
            .pickerStyle(.inline)
        }
        .navigationTitle("prayer_times_calculation_method")
    }
}

#Preview {
    PrayerTimesCalculationMethodView(store: Store(
        initialState: PrayerTimesCalculationMethodFeature.State(),
        reducer: PrayerTimesCalculationMethodFeature.init
    ))
}

#Preview {
    PrayerTimesCalculationMethodView(store: Store(
        initialState: PrayerTimesCalculationMethodFeature.State(),
        reducer: PrayerTimesCalculationMethodFeature.init
    ))
    .arabicEnvironment()
}
