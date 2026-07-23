//
//  TimeAdjustmentsView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 23/07/2026.
//

import ComposableArchitecture
import SwiftUI

struct TimeAdjustmentsView: View {
    @Bindable var store: StoreOf<TimeAdjustmentsFeature>

    var body: some View {
        Form {
            adjustmentStepper("fajr", value: $store.fajr, time: store.preview?.fajr)
            adjustmentStepper("sunrise", value: $store.sunrise, time: store.preview?.sunrise)
            adjustmentStepper("dhuhr", value: $store.dhuhr, time: store.preview?.dhuhr)
            adjustmentStepper("asr", value: $store.asr, time: store.preview?.asr)
            adjustmentStepper("maghrib", value: $store.maghrib, time: store.preview?.maghrib)
            adjustmentStepper("ishaa", value: $store.ishaa, time: store.preview?.ishaa)
        }
        .navigationTitle("time_adjustments")
        .onAppear { store.send(.view(.onAppear)) }
    }

    private func adjustmentStepper(
        _ title: LocalizedStringKey,
        value: Binding<Int>,
        time: Date?
    ) -> some View {
        Stepper(value: value, in: TimeAdjustmentsFeature.adjustmentRange) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.extraExtraSmall) {
                    Text(title)
                    if let time {
                        Text(time, format: .dateTime.hour().minute())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Text(value.wrappedValue.minutesLabel)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private extension Int {
    /// Formats a per-prayer offset in signed minutes (e.g. `+3 min`, `0 min`, `-2 min`).
    var minutesLabel: String {
        let sign = self > 0 ? "+" : ""
        return "\(sign)\(self) \(String(localized: "minutes_short"))"
    }
}

#Preview {
    NavigationStack {
        TimeAdjustmentsView(store: Store(
            initialState: TimeAdjustmentsFeature.State(),
            reducer: TimeAdjustmentsFeature.init
        ))
    }
}
