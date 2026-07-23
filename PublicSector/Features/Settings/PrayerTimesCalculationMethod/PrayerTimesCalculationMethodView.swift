//
//  PrayerTimesCalculationMethodView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 26/03/2026.
//

import ComposableArchitecture
import SwiftUI

struct PrayerTimesCalculationMethodView: View {
    @Bindable var store: StoreOf<PrayerTimesCalculationMethodFeature>

    var body: some View {
        Form {
            calculationMethodPicker

            switch store.calculationMethod {
            case .astronomical:
                astronomicalRows
            case .precomputed:
                precomputedMethodPicker
            }
        }
        .navigationTitle("prayer_times_calculation_method")
        .onAppear { store.send(.view(.onAppear)) }
        .navigationDestination(
            item: $store.scope(
                state: \.destination?.calculationMethodSelection,
                action: \.dependent
                    .destination.calculationMethodSelection
            ),
            destination: { CalculationMethodSelectionView(store: $0) }
        )
        .navigationDestination(
            item: $store.scope(
                state: \.destination?.asrMethod,
                action: \.dependent.destination.asrMethod
            ),
            destination: { AsrMethodView(store: $0) }
        )
        .navigationDestination(
            item: $store.scope(
                state: \.destination?.timeAdjustments,
                action: \.dependent.destination.timeAdjustments
            ),
            destination: { TimeAdjustmentsView(store: $0) }
        )
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

    @ViewBuilder
    private var astronomicalRows: some View {
        Section {
            NavigationRowView(
                "astronomical_method",
                badge: store.methodBadge.isEmpty ? nil : store.methodBadge,
                systemName: "slider.horizontal.3"
            )
            .onTapGesture { store.send(.view(.methodTapped)) }

            NavigationRowView(
                "asr_method",
                badge: store.madhabBadge.isEmpty ? nil : store.madhabBadge,
                systemName: "sun.max"
            )
            .onTapGesture { store.send(.view(.asrMethodTapped)) }

            NavigationRowView("time_adjustments", systemName: "clock.arrow.2.circlepath")
                .onTapGesture { store.send(.view(.timeAdjustmentsTapped)) }
        }
    }

    private var precomputedMethodPicker: some View {
        Text("dar_el_fatwa_beirut")
    }
}

#Preview {
    NavigationStack {
        PrayerTimesCalculationMethodView(store: Store(
            initialState: PrayerTimesCalculationMethodFeature.State(),
            reducer: PrayerTimesCalculationMethodFeature.init
        ))
    }
}

#Preview {
    NavigationStack {
        PrayerTimesCalculationMethodView(store: Store(
            initialState: PrayerTimesCalculationMethodFeature.State(),
            reducer: PrayerTimesCalculationMethodFeature.init
        ))
    }
    .arabicEnvironment()
}
