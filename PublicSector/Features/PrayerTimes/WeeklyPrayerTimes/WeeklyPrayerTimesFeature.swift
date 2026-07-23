//
//  WeeklyPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import Foundation
import MiqatKit
import UIKit

@Reducer
struct WeeklyPrayerTimesFeature {
    @Dependency(\.miqatService) private var miqatService

    @ObservableState
    struct State: Equatable {
        var date: Date = .now
        var week: [DayInfo] = []
        var isRenderingShareImage = false
        var shareImage: ShareableImage?

        /// A note describing the active non-default calculation method (method · mazhab),
        /// or `nil` when the default precomputed provider is used and nothing should be shown.
        var calculationNote: String?

        var hasImsak: Bool { week.contains(where: { $0.imsak != nil }) }
        var isLoading: Bool { week.isEmpty }
    }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onAppear
            /// The user tapped share. `render` builds the snapshot on the main
            /// actor; it is invoked from an effect so the tap returns immediately
            /// and the render happens on a later run-loop turn.
            case shareTapped(render: @MainActor @Sendable () -> UIImage)
        }

        @CasePathable
        enum ReducerAction {
            case shareImageRendered(UIImage)
        }

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
                fillWeek(state: &state)
                return .none

            case let .view(.shareTapped(render)):
                guard !state.isRenderingShareImage else { return .none }
                state.isRenderingShareImage = true
                return .run { send in
                    // Hop off the current run-loop turn so the tap is not blocked
                    // by rendering, then rasterize on the main actor as
                    // `ImageRenderer` requires.
                    await Task.yield()
                    let image = await MainActor.run { render() }
                    await send(.reducer(.shareImageRendered(image)))
                }

            case let .reducer(.shareImageRendered(image)):
                state.isRenderingShareImage = false
                state.shareImage = ShareableImage(image: image)
                return .none

            case .binding(\.date):
                fillWeek(state: &state)
                return .none

            default:
                return .none
            }
        }
    }

    private func fillWeek(state: inout State) {
        let calendar = Calendar.current
        let date = state.date
        let weekday = calendar.component(.weekday, from: date) // 1=Sun…7=Sat
        let daysBack = weekday % 7 // Sat→0, Sun→1, …, Fri→6
        guard let saturday = calendar.date(byAdding: .day, value: -daysBack, to: date) else { return }

        let tzOffset = TimeZone.current.secondsFromGMT()

        state.week = (0..<7).compactMap { i in
            guard let dayDate = calendar.date(byAdding: .day, value: i, to: saturday) else { return nil }
            let timestamp = dayDate.timeIntervalSince1970 + TimeInterval(tzOffset)
            let miqatData = miqatService.getMiqatData(timestampSecs: timestamp)
            return DayInfo(from: miqatData)
        }
        state.calculationNote = calculationNote()
    }

    /// Builds the note for the active method. Only astronomical methods produce a note;
    /// the default precomputed provider (Dar El Fatwa Beirut) returns `nil`.
    private func calculationNote() -> String? {
        switch miqatService.getCalculationMethod() {
        case .precomputed:
            return nil
        case let .astronomical(config):
            let methodName = switch config.method {
            case let .preset(method): method.string
            case .custom: String(localized: "method_custom")
            }
            return String(
                format: String(localized: "prayer_times_calculation_note"),
                methodName,
                config.mazhab.string
            )
        }
    }
}
