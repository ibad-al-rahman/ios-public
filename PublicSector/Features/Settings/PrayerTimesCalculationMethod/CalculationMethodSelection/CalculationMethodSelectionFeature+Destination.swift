//
//  CalculationMethodSelectionFeature+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 23/07/2026.
//

import ComposableArchitecture

extension CalculationMethodSelectionFeature {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case locationSearch(LocationSearchFeature.State)
        }

        enum Action {
            case locationSearch(LocationSearchFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.locationSearch, action: \.locationSearch) {
                LocationSearchFeature()
            }
        }
    }
}
