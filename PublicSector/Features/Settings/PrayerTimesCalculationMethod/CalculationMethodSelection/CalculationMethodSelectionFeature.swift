//
//  CalculationMethodSelectionFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 23/07/2026.
//

import ComposableArchitecture
import Foundation
import MiqatKit

@Reducer
struct CalculationMethodSelectionFeature {
    @Dependency(\.miqatService) private var miqatService
    @Dependency(\.prayerTimesNotificationScheduler.scheduleNotifications) private var scheduleNotifications
    @Dependency(\.widgetReloader.reloadAll) private var reloadWidgets
    @Dependency(\.date.now) private var now

    /// Bounds for the custom-provider twilight angles (degrees below the horizon).
    static let customAngleRange: ClosedRange<Double> = 10.0...29.5
    static let customAngleStep: Double = 0.5

    /// The astronomical method choice as shown in the picker: one of the presets, or custom.
    enum AstronomicalMethodSelection: Hashable, CaseIterable, Identifiable {
        case preset(Miqat.Method)
        case custom

        static var allCases: [AstronomicalMethodSelection] {
            Miqat.Method.allCases.map(Self.preset) + [.custom]
        }

        var id: String {
            switch self {
            case let .preset(method): method.identifier
            case .custom: "custom"
            }
        }

        var string: String {
            switch self {
            case let .preset(method): method.string
            case .custom: String(localized: "method_custom")
            }
        }
    }

    @ObservableState
    struct State: Equatable {
        var astronomicalMethod: AstronomicalMethodSelection = .preset(.muslimWorldLeague)
        var customFajrAngle: Double = 18.0
        var customIshaaAngle: Double = 17.0
        @Shared(.selectedLocation) var selectedLocation: Settings.SelectedLocation? = nil

        @Presents var destination: Destination.State?

        /// Prayer times for today under the current selection, shown as a live preview.
        /// `nil` when no location is set (astronomical cannot compute without coordinates).
        var preview: MiqatData?

        /// Astronomical configuration is only meaningful once a location is chosen; the astronomical
        /// path cannot compute without coordinates.
        var isAstronomicalConfigurable: Bool { selectedLocation != nil }
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
                refreshPreview(state: &state)
                return .none

            case .view(.locationSearchTapped):
                state.destination = .locationSearch(LocationSearchFeature.State())
                return .none

            case .binding(\.astronomicalMethod),
                 .binding(\.customFajrAngle),
                 .binding(\.customIshaaAngle):
                return persist(state: &state)

            case let .dependent(.destination(.presented(.locationSearch(.delegate(.didSelectLocation(location)))))):
                state.$selectedLocation.withLock { $0 = location }
                return persist(state: &state)

            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.dependent.destination) {
            Destination()
        }
    }

    /// Populates the astronomical sub-fields from the retained config (or the active one) when one
    /// exists, so reopening the screen shows the last method and angles.
    private func hydrate(state: inout State) {
        guard let config = miqatService.getRetainedAstronomicalConfig()
            ?? miqatService.getCalculationMethod().asAstronomical
        else { return }
        switch config.method {
        case let .preset(method):
            state.astronomicalMethod = .preset(method)
        case let .custom(fajrAngle, ishaaAngle):
            state.astronomicalMethod = .custom
            state.customFajrAngle = fajrAngle
            state.customIshaaAngle = ishaaAngle
        }
    }

    /// Builds the astronomical method from the current selection, preserving the madhab and per-prayer
    /// offsets that the sibling screens own. `nil` when no location is set (astronomical requires
    /// coordinates).
    private func buildMethod(state: State) -> MiqatPrayerTimesCalculationMethod? {
        guard let location = state.selectedLocation else { return nil }

        let astronomicalMethod: AstronomicalMethod = switch state.astronomicalMethod {
        case let .preset(preset):
            .preset(preset)
        case .custom:
            .custom(fajrAngle: state.customFajrAngle, ishaaAngle: state.customIshaaAngle)
        }
        // Preserve madhab/adjustments from the retained astronomical config (survives toggles to
        // precomputed), falling back to the active one, then to defaults.
        let existing = miqatService.getRetainedAstronomicalConfig()
            ?? miqatService.getCalculationMethod().asAstronomical
        return .astronomical(AstronomicalConfig(
            coordinates: Miqat.Coordinates(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            method: astronomicalMethod,
            mazhab: existing?.mazhab ?? .shafi,
            adjustments: existing?.adjustments ?? .zero
        ))
    }

    /// Persists the method choice, refreshes the preview to match, and reschedules dependent work.
    private func persist(state: inout State) -> Effect<Action> {
        guard let method = buildMethod(state: state) else { return .none }
        miqatService.setCalculationMethod(method)
        state.preview = miqatService.previewMiqatData(timestampSecs: previewTimestamp, method: method)
        return .run { _ in
            await scheduleNotifications()
            reloadWidgets()
        }
    }

    /// Recomputes the preview from the current selection without persisting.
    private func refreshPreview(state: inout State) {
        guard let method = buildMethod(state: state) else {
            state.preview = nil
            return
        }
        state.preview = miqatService.previewMiqatData(timestampSecs: previewTimestamp, method: method)
    }

    /// Timestamp for today, offset to match how prayer time screens feed dates into MiqatKit.
    private var previewTimestamp: TimeInterval {
        now.timeIntervalSince1970 + TimeInterval(TimeZone.current.secondsFromGMT())
    }
}
