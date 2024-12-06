//
//  StartupFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/12/2024.
//

import ComposableArchitecture

@Reducer
struct StartupFeature {
    @Dependency(\.prayerTimesRepository) private var prayerTimesRepository

    @ObservableState
    struct State: Equatable {
        @Shared(.sha1) var sha1 = nil
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case dependent(DependentAction)
        case delegate(DelegateAction)

        enum ViewAction {
            case onAppear
        }

        @CasePathable
        enum ReducerAction {
            case getSha1(String?)
        }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { send in
                    let sha1 = await prayerTimesRepository.getSha1()
                    await send(.reducer(.getSha1(sha1)))
                }

            case .reducer(.getSha1(let sha1)):
                state.sha1 = sha1
                return .none

            default:
                return .none
            }
        }
    }
}
