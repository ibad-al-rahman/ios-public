//
//  TimeAdjustmentsFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 23/07/2026.
//

import ComposableArchitecture
import Foundation
import MiqatKit

@Reducer
struct TimeAdjustmentsFeature {
    @Dependency(\.miqatService) private var miqatService
    @Dependency(\.prayerTimesNotificationScheduler.scheduleNotifications) private var scheduleNotifications
    @Dependency(\.widgetReloader.reloadAll) private var reloadWidgets
    @Dependency(\.date.now) private var now

    /// Bounds for the per-prayer time adjustments, in minutes.
    static let adjustmentRange: ClosedRange<Int> = -60...60

    @ObservableState
    struct State: Equatable {
        var fajr: Int = 0
        var sunrise: Int = 0
        var dhuhr: Int = 0
        var asr: Int = 0
        var maghrib: Int = 0
        var ishaa: Int = 0

        /// Prayer times for today under the current offsets, shown inline beneath each stepper.
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
                    let adjustments = config.adjustments
                    state.fajr = Int(adjustments.fajr)
                    state.sunrise = Int(adjustments.sunrise)
                    state.dhuhr = Int(adjustments.dhuhr)
                    state.asr = Int(adjustments.asr)
                    state.maghrib = Int(adjustments.maghrib)
                    state.ishaa = Int(adjustments.ishaa)
                }
                refreshPreview(state: &state)
                return .none

            case .binding(\.fajr),
                 .binding(\.sunrise),
                 .binding(\.dhuhr),
                 .binding(\.asr),
                 .binding(\.maghrib),
                 .binding(\.ishaa):
                return persist(state: &state)

            default:
                return .none
            }
        }
    }

    /// Builds the method from the persisted astronomical config with the current offsets applied.
    /// `nil` when there is no astronomical config (only reachable in astronomical mode in practice).
    private func buildMethod(state: State) -> MiqatPrayerTimesCalculationMethod? {
        guard var config = miqatService.getCalculationMethod().asAstronomical else { return nil }
        config.adjustments = Miqat.TimeAdjustment(
            fajr: Int64(state.fajr),
            sunrise: Int64(state.sunrise),
            dhuhr: Int64(state.dhuhr),
            asr: Int64(state.asr),
            maghrib: Int64(state.maghrib),
            ishaa: Int64(state.ishaa)
        )
        return .astronomical(config)
    }

    /// Writes the offsets back into the persisted config, refreshes the preview, and reschedules work.
    private func persist(state: inout State) -> Effect<Action> {
        guard let method = buildMethod(state: state) else { return .none }
        miqatService.setCalculationMethod(method)
        state.preview = miqatService.previewMiqatData(timestampSecs: previewTimestamp, method: method)
        return .run { _ in
            await scheduleNotifications()
            reloadWidgets()
        }
    }

    /// Recomputes the preview from the current offsets without persisting.
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
