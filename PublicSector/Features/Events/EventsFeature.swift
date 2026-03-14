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
        var year: Int = 2026
        var query: String = ""
        var events: [MiqatEventOccurrence] = []
        var filteredEvents: [MiqatEventOccurrence] {
            events
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

            default:
                return .none
            }
        }
    }
}
