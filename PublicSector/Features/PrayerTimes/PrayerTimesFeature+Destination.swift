//
//  PrayerTimesFeature+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture

extension PrayerTimesFeature {
    @Reducer
    struct Destination {
        enum State: Identifiable, Equatable {
            case edit(EditPrayerTimesFeature.State)

            var id: AnyHashable {
                switch self {
                case .edit: "edit"
                }
            }
        }

        enum Action {
            case edit(EditPrayerTimesFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.edit, action: \.edit) {
                EditPrayerTimesFeature()
            }
        }
    }
}
