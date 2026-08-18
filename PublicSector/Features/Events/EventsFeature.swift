//
//  EventsFeature.swift
//  PublicSector
//
//  Created by May Chehab on 05/03/2026.
//

import ComposableArchitecture
import Foundation
import IbadAnalytics
import MiqatKit

@Reducer
struct EventsFeature {
    @Dependency(\.miqatService) private var miqatService

    @ObservableState
    struct State: Equatable {
        /// Number of years the picker may step forward/back from the current year.
        static let yearRange = 5

        var year: Int = Calendar.current.component(.year, from: Date())
        var query: String = ""
        var events: [MiqatEventOccurrence] = []

        var minYear: Int { Calendar.current.component(.year, from: Date()) - Self.yearRange }
        var maxYear: Int { Calendar.current.component(.year, from: Date()) + Self.yearRange }
        var canDecrementYear: Bool { year > minYear }
        var canIncrementYear: Bool { year < maxYear }
        var filteredEvents: [MiqatEventOccurrence] {
            guard !query.isEmpty else { return events }
            return events.filter { occurrence in
                occurrence
                    .event
                    .string
                    .localizedCaseInsensitiveContains(query)
            }
        }
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
        AnalyticsReducer { _, action in
            switch action {
            case .view(.onAppear):
                return .screen(name: "Events")

            default:
                return .none
            }
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.events = miqatService.getIslamicEvents(year: state.year)
                return .none

            case .binding(\.year):
                let currentYear = Calendar.current.component(.year, from: Date())
                state.year = min(max(state.year, currentYear - State.yearRange), currentYear + State.yearRange)
                state.events = miqatService.getIslamicEvents(year: state.year)
                return .none

            default:
                return .none
            }
        }
    }
}
