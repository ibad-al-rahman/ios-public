//
//  AdhkarFeature+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 06/03/2026.
//

import ComposableArchitecture

extension AdhkarFeature {
    @Reducer
    struct Destination {
        enum State: Identifiable, Equatable {
            case morning(DhikrListFeature.State)
            case evening(DhikrListFeature.State)

            var id: AnyHashable {
                switch self {
                case .morning: "morning"
                case .evening: "evening"
                }
            }
        }

        enum Action {
            case morning(DhikrListFeature.Action)
            case evening(DhikrListFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.morning, action: \.morning) {
                DhikrListFeature()
            }

            Scope(state: \.evening, action: \.evening) {
                DhikrListFeature()
            }
        }
    }
}
