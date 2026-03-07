//
//  DhikrListFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 06/03/2026.
//

import ComposableArchitecture

@Reducer
struct DhikrListFeature {
    enum ViewMode: Equatable {
        case list
        case journey
    }

    @ObservableState
    struct State: Equatable {
        let category: AdhkarCategory
        var remaining: [Int: Int] = [:]
        var viewMode: ViewMode = .list
        var journeyIndex: Int = 0
        var selectedDhikrInfo: Dhikr? = nil

        var adhkar: [Dhikr] {
            switch category {
            case .morning: AdhkarData.morning
            case .evening: AdhkarData.evening
            case .afterPrayer: AdhkarData.afterPrayer
            case .beforeSleep: AdhkarData.beforeSleep
            case .wakingUp: AdhkarData.wakingUp
            case .eating: AdhkarData.eating
            case .generalSupplications: AdhkarData.generalSupplications
            }
        }

        var overallProgress: Double {
            let total = adhkar.reduce(0) { $0 + $1.count }
            let done = adhkar.reduce(0) { sum, dhikr in
                let rem = remaining[dhikr.id] ?? dhikr.count
                return sum + (dhikr.count - rem)
            }
            return total > 0 ? Double(done) / Double(total) : 0
        }

        var currentJourneyDhikr: Dhikr? {
            guard journeyIndex < adhkar.count else { return nil }
            return adhkar[journeyIndex]
        }
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case onDhikrTapped(Dhikr)
            case onDhikrReset(Dhikr)
            case onToggleViewMode
            case onJourneyNext
            case onJourneyPrevious
            case onInfoTapped(Dhikr)
            case onInfoDismissed
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onDhikrTapped(let dhikr)):
                let current = state.remaining[dhikr.id] ?? dhikr.count
                guard current > 0 else { return .none }
                state.remaining[dhikr.id] = current - 1
                return .none

            case .view(.onDhikrReset(let dhikr)):
                state.remaining[dhikr.id] = dhikr.count
                return .none

            case .view(.onToggleViewMode):
                state.viewMode = state.viewMode == .list ? .journey : .list
                // Jump to first incomplete dhikr when entering journey mode
                if state.viewMode == .journey {
                    let firstIncomplete = state.adhkar.firstIndex {
                        (state.remaining[$0.id] ?? $0.count) > 0
                    }
                    state.journeyIndex = firstIncomplete ?? 0
                }
                return .none

            case .view(.onJourneyNext):
                if state.journeyIndex < state.adhkar.count - 1 {
                    state.journeyIndex += 1
                }
                return .none

            case .view(.onJourneyPrevious):
                if state.journeyIndex > 0 {
                    state.journeyIndex -= 1
                }
                return .none

            case .view(.onInfoTapped(let dhikr)):
                state.selectedDhikrInfo = dhikr
                return .none

            case .view(.onInfoDismissed):
                state.selectedDhikrInfo = nil
                return .none

            default:
                return .none
            }
        }
    }
}
