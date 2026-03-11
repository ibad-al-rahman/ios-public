//
//  EventsFeature.swift
//  PublicSector
//
//  Created by May Chehab on 05/03/2026.
//

import ComposableArchitecture
import Foundation
import IbadAnalytics

@Reducer
struct EventsFeature {
    struct EventSearchResult: Equatable, Identifiable {
        let id: Int
        let gregorian: Date
        let hijri: String
        let ar: String
        let en: String?
    }

    @ObservableState
    struct State: Equatable {
        var query: String = ""
        var allEvents: [EventSearchResult] = []
        var isLoading: Bool = false

        var filteredResults: [EventSearchResult] {
            let trimmed = query.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return allEvents }
            return allEvents.filter { result in
                result.ar.localizedCaseInsensitiveContains(trimmed) ||
                (result.en?.localizedCaseInsensitiveContains(trimmed) ?? false)
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
        enum ReducerAction {
            case loadEvents([EventSearchResult])
        }

        @CasePathable enum DelegateAction { }
        @CasePathable enum DependentAction { }
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
                guard state.allEvents.isEmpty else { return .none }
                state.isLoading = true
                return loadEvents()

            case .reducer(.loadEvents(let results)):
                state.allEvents = results
                state.isLoading = false
                return .none

            default:
                return .none
            }
        }
    }

    private func loadEvents() -> EffectOf<Self> {
        .run { send in
            guard let year = Date.now.ymd?.year else { return }

            let gregorianFormatter = DateFormatter()
            gregorianFormatter.dateFormat = "dd/MM/yyyy"
            gregorianFormatter.locale = Locale(identifier: "en_US_POSIX")
            gregorianFormatter.calendar = Calendar(identifier: .gregorian)

            let hijriFormatter = DateFormatter()
            hijriFormatter.calendar = Calendar(identifier: .islamicUmmAlQura)
            hijriFormatter.dateFormat = "dd/MM/yyyy"

            let results: [EventSearchResult] = []

            await send(.reducer(.loadEvents(results)), animation: .default)
        }
    }
}
