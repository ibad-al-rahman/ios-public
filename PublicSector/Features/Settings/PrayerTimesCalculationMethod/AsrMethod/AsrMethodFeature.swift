//
//  AsrMethodFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 23/07/2026.
//

import ComposableArchitecture
import Foundation
import MiqatKit

@Reducer
struct AsrMethodFeature {
    @Dependency(\.miqatService) private var miqatService
    @Dependency(\.prayerTimesNotificationScheduler.scheduleNotifications) private var scheduleNotifications
    @Dependency(\.widgetReloader.reloadAll) private var reloadWidgets
    @Dependency(\.date.now) private var now

    @ObservableState
    struct State: Equatable {
        var mazhab: Miqat.Mazhab = .shafi

        /// Prayer times for today under the current madhab, shown as a live preview.
        var preview: MiqatData?
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onAppear
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                if let config = miqatService.getCalculationMethod().asAstronomical {
                    state.mazhab = config.mazhab
                }
                refreshPreview(state: &state)
                return .none

            case .binding(\.mazhab):
                return persist(state: &state)

            default:
                return .none
            }
        }
    }

    /// Builds the method from the persisted astronomical config with the current madhab applied.
    /// `nil` when there is no astronomical config (only reachable in astronomical mode in practice).
    private func buildMethod(state: State) -> MiqatPrayerTimesCalculationMethod? {
        guard var config = miqatService.getCalculationMethod().asAstronomical else { return nil }
        config.mazhab = state.mazhab
        return .astronomical(config)
    }

    /// Writes the madhab back into the persisted config, refreshes the preview, and reschedules work.
    private func persist(state: inout State) -> Effect<Action> {
        guard let method = buildMethod(state: state) else { return .none }
        miqatService.setCalculationMethod(method)
        state.preview = miqatService.previewMiqatData(timestampSecs: previewTimestamp, method: method)
        return .run { _ in
            await scheduleNotifications()
            reloadWidgets()
        }
    }

    /// Recomputes the preview from the current madhab without persisting.
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
