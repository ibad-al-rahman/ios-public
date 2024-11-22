//
//  EditPrayerTimesFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture

@Reducer
struct EditPrayerTimesFeature {
    @ObservableState
    struct State: Equatable {
        var fajerState = EditSinglePrayerTimeFeature.State()
        var sunriseState = EditSinglePrayerTimeFeature.State()
        var dhuhrState = EditSinglePrayerTimeFeature.State()
        var asrState = EditSinglePrayerTimeFeature.State()
        var maghribState = EditSinglePrayerTimeFeature.State()
        var ishaaState = EditSinglePrayerTimeFeature.State()
    }

    enum Action: BaseAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)

        enum ViewAction { }

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
        EmptyReducer()
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
