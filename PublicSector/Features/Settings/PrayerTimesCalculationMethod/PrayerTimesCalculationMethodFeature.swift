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
    @Dependency(\.miqatService) private var miqatService
    @Dependency(\.prayerTimesNotificationScheduler.scheduleNotifications) private var scheduleNotifications
    @Dependency(\.widgetReloader.reloadAll) private var reloadWidgets

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
        var astronomicalMethod: Miqat.Method = .muslimWorldLeague
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
            case onAppear
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
            case .view(.onAppear):
                hydrate(state: &state)
                return .none

            case .view(.locationSearchTapped):
                state.destination = .locationSearch(LocationSearchFeature.State())
                return .none

            case .binding(\.calculationMethod), .binding(\.astronomicalMethod):
                return persist(state: state)

            case let .dependent(.destination(.presented(.locationSearch(.delegate(.didSelectLocation(location)))))):
                state.$selectedLocation.withLock { $0 = location }
                return persist(state: state)

            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }

    /// Populates the UI from the persisted calculation method so the screen reflects the
    /// current selection when it opens.
    private func hydrate(state: inout State) {
        switch miqatService.getCalculationMethod() {
        case let .astronomical(method, _):
            state.calculationMethod = .astronomical
            state.astronomicalMethod = method
        case .precomputed:
            state.calculationMethod = .precomputed
        }
    }

    /// Builds a `MiqatPrayerTimesCalculationMethod` from the UI state and persists it through
    /// the service. Astronomical requires a location; without one we fall back to precomputed.
    private func persist(state: State) {
    private func persist(state: State) -> Effect<Action> {
        let method: MiqatPrayerTimesCalculationMethod
        switch state.calculationMethod {
        case .astronomical:
            if let location = state.selectedLocation {
                method = .astronomical(
                    state.astronomicalMethod,
                    Miqat.Coordinates(latitude: location.latitude, longitude: location.longitude)
                )
            } else {
                method = .default
            }
        case .precomputed:
            method = .precomputed(.darElFatwa(.beirut))
        }
        miqatService.setCalculationMethod(method)
        return .run { _ in
            await scheduleNotifications()
            reloadWidgets()
        }
    }
}
