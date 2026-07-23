//
//  PrayerTimesCalculationMethodFeature+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 27/03/2026.
//

import ComposableArchitecture

extension PrayerTimesCalculationMethodFeature {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case calculationMethodSelection(CalculationMethodSelectionFeature.State)
            case asrMethod(AsrMethodFeature.State)
            case timeAdjustments(TimeAdjustmentsFeature.State)
        }

        enum Action {
            case calculationMethodSelection(CalculationMethodSelectionFeature.Action)
            case asrMethod(AsrMethodFeature.Action)
            case timeAdjustments(TimeAdjustmentsFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.calculationMethodSelection, action: \.calculationMethodSelection) {
                CalculationMethodSelectionFeature()
            }
            Scope(state: \.asrMethod, action: \.asrMethod) {
                AsrMethodFeature()
            }
            Scope(state: \.timeAdjustments, action: \.timeAdjustments) {
                TimeAdjustmentsFeature()
            }
        }
    }
}
