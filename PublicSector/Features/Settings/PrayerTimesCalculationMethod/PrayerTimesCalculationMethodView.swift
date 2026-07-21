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
        .onAppear { store.send(.view(.onAppear)) }
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
            if let location = store.selectedLocation?.name {
                NavigationRowView("location", badge: location, systemName: "location")
                    .onTapGesture { store.send(.view(.locationSearchTapped)) }
            } else {
                NavigationRowView("location", systemName: "location")
                    .onTapGesture { store.send(.view(.locationSearchTapped)) }
            }

            Picker(selection: $store.astronomicalMethod) {
                ForEach(Miqat.Method.allCases, id: \.self) {
                    Text($0.string).tag($0)
                }
            } label: {
                Spacer(minLength: Spacing.small)
            }
            .pickerStyle(.inline)
        }
    }

    private var precomputedMethodPicker: some View {
        Text("dar_el_fatwa_beirut")
    }
}

extension Miqat.Method: @retroactive CaseIterable {
    public static var allCases: [Miqat.Method] {
        [.muslimWorldLeague, .egyptian, .ummAlQura, .moonsightingCommittee, .northAmerica, .singapore]
    }

    var string: String {
        switch self {
        case .muslimWorldLeague: String(localized: "method_muslim_world_league")
        case .egyptian: String(localized: "method_egyptian")
        case .ummAlQura: String(localized: "method_umm_al_qura")
        case .moonsightingCommittee: String(localized: "method_moonsighting_committee")
        case .northAmerica: String(localized: "method_north_america")
        case .singapore: String(localized: "method_singapore")
        }
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
