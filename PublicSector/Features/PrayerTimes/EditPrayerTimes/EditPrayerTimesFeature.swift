//
//  EditPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture

@Reducer
struct EditPrayerTimesFeature {
    @Dependency(\.dismiss) private var dismiss

    @ObservableState
    struct State: Equatable {
        var fajerState = EditSinglePrayerTimeFeature.State(prayer: .fajer)
        var sunriseState = EditSinglePrayerTimeFeature.State(prayer: .sunrise)
        var dhuhrState = EditSinglePrayerTimeFeature.State(prayer: .dhuhr)
        var asrState = EditSinglePrayerTimeFeature.State(prayer: .asr)
        var maghribState = EditSinglePrayerTimeFeature.State(prayer: .maghrib)
        var ishaaState = EditSinglePrayerTimeFeature.State(prayer: .ishaa)
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction {
            case onTapDone
        }

        @CasePathable
        enum ReducerAction { }

        @CasePathable
        enum DelegateAction { }

        @CasePathable
        enum DependentAction {
            case fajer(EditSinglePrayerTimeFeature.Action)
            case sunrise(EditSinglePrayerTimeFeature.Action)
            case dhuhr(EditSinglePrayerTimeFeature.Action)
            case asr(EditSinglePrayerTimeFeature.Action)
            case maghrib(EditSinglePrayerTimeFeature.Action)
            case ishaa(EditSinglePrayerTimeFeature.Action)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onTapDone):
                return .run { _ in await dismiss() }

            default: return .none
            }
        }

        Scope(state: \.fajerState, action: \.dependent.fajer) {
            EditSinglePrayerTimeFeature()
        }
        Scope(state: \.sunriseState, action: \.dependent.sunrise) {
            EditSinglePrayerTimeFeature()
        }
        Scope(state: \.dhuhrState, action: \.dependent.dhuhr) {
            EditSinglePrayerTimeFeature()
        }
        Scope(state: \.asrState, action: \.dependent.asr) {
            EditSinglePrayerTimeFeature()
        }
        Scope(state: \.maghribState, action: \.dependent.maghrib) {
            EditSinglePrayerTimeFeature()
        }
        Scope(state: \.ishaaState, action: \.dependent.ishaa) {
            EditSinglePrayerTimeFeature()
        }
    }
}
