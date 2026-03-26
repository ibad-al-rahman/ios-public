//
//  PrayerTimesCalculationMethodFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 26/03/2026.
//

import ComposableArchitecture
import MiqatKit

@Reducer
struct PrayerTimesCalculationMethodFeature {
    enum CalculationMethod: Equatable, CaseIterable, Identifiable {
        case astronomical
        case precomputed

        var id: String {
            switch self {
            case .astronomical: "astronomical"
            case .precomputed: "precomputed"
            }
        }

        var string: String {
            switch self {
            case .astronomical: String(localized: "astronomical_method")
            case .precomputed: String(localized: "precomputed_method")
            }
        }
    }

    @ObservableState
    struct State: Equatable {
        var calculationMethod: CalculationMethod = .astronomical
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction { }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { _, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
