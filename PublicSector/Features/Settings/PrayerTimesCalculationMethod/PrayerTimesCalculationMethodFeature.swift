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
            case .astronomical: String(localized: "astronomical_mode")
            case .precomputed: String(localized: "precomputed_method")
            }
        }
    }

    @ObservableState
    struct State: Equatable {
        var calculationMethod: CalculationMethod = .precomputed
        /// Summary badges shown on the menu rows.
        var methodBadge: String = ""
        var madhabBadge: String = ""

        @Presents var destination: Destination.State?

        /// Astronomical options rows only apply to the astronomical path.
        var isAstronomical: Bool { calculationMethod == .astronomical }
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onAppear
            case methodTapped
            case asrMethodTapped
            case timeAdjustmentsTapped
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

            case .binding(\.calculationMethod):
                return persistMethodKind(state: &state)

            case .view(.methodTapped):
                state.destination = .calculationMethodSelection(CalculationMethodSelectionFeature.State())
                return .none

            case .view(.asrMethodTapped):
                state.destination = .asrMethod(AsrMethodFeature.State())
                return .none

            case .view(.timeAdjustmentsTapped):
                state.destination = .timeAdjustments(TimeAdjustmentsFeature.State())
                return .none

            case .dependent(.destination(.dismiss)):
                // Refresh badges after returning from a sub-screen.
                hydrate(state: &state)
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }

    /// Refreshes the toggle and menu row badges from the persisted method. Runs on every appearance
    /// so the menu reflects edits made in the pushed sub-screens after popping back.
    private func hydrate(state: inout State) {
        switch miqatService.getCalculationMethod() {
        case let .astronomical(config):
            state.calculationMethod = .astronomical
            state.methodBadge = switch config.method {
            case let .preset(method): method.string
            case .custom: String(localized: "method_custom")
            }
            state.madhabBadge = config.mazhab.string
        case .precomputed:
            state.calculationMethod = .precomputed
            state.methodBadge = ""
            state.madhabBadge = ""
        }
    }

    /// Persists a change to the astronomical/precomputed kind. Switching to astronomical restores the
    /// previously-retained astronomical config (location, method, madhab, offsets) so nothing has to
    /// be reconfigured; only when the user has never configured one do we push the options screen so a
    /// location can be picked.
    private func persistMethodKind(state: inout State) -> Effect<Action> {
        let method: MiqatPrayerTimesCalculationMethod
        switch state.calculationMethod {
        case .astronomical:
            guard let config = miqatService.getRetainedAstronomicalConfig() else {
                // Never configured astronomical — push the options screen to complete it (needs a location).
                state.destination = .calculationMethodSelection(CalculationMethodSelectionFeature.State())
                return .none
            }
            method = .astronomical(config)
        case .precomputed:
            method = .precomputed(.darElFatwa(.beirut))
        }
        miqatService.setCalculationMethod(method)
        hydrate(state: &state)
        return .run { _ in
            await scheduleNotifications()
            reloadWidgets()
        }
    }
}
