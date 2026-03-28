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
        @Shared(.selectedLocation) var selectedLocation: Settings.SelectedLocation? = nil

        @Presents var destination: Destination.State?
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case locationSearchTapped
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case destination(PresentationAction<Destination.Action>)
        }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.locationSearchTapped):
                state.destination = .locationSearch(LocationSearchFeature.State())
                return .none

            case let .dependent(.destination(.presented(.locationSearch(.delegate(.didSelectLocation(location)))))):
                state.$selectedLocation.withLock { $0 = location }
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }
}
