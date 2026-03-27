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
            calculationMethodPicker

            switch store.calculationMethod {
            case .astronomical:
                astronomicalMethodPicker

            case .precomputed:
                precomputedMethodPicker
            }
        }
        .navigationTitle("prayer_times_calculation_method")
        .sheet(item: $store.scope(
            state: \.destination?.locationSearch,
            action: \.dependent.destination.locationSearch
        )) { store in
            NavigationStack {
                LocationSearchView(store: store)
            }
        }
    }

    private var calculationMethodPicker: some View {
        Picker(selection: $store.calculationMethod) {
            ForEach(PrayerTimesCalculationMethodFeature.CalculationMethod.allCases) {
                Text($0.string).tag($0)
            }
        } label: {
            Spacer(minLength: Spacing.small)
        }
        .pickerStyle(.inline)
    }

    private var astronomicalMethodPicker: some View {
        Group {
            Button {
                store.send(.view(.locationSearchTapped))
            } label: {
                Text(verbatim: "Location")
                    .foregroundStyle(.primary)
            }
            Text(verbatim: "Astronomical")
        }
    }

    private var precomputedMethodPicker: some View {
        Text(verbatim: "Precomputed")
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
