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
            case afterPrayer(DhikrListFeature.State)
            case beforeSleep(DhikrListFeature.State)
            case wakingUp(DhikrListFeature.State)
            case eating(DhikrListFeature.State)
            case generalSupplications(DhikrListFeature.State)

            var id: AnyHashable {
                switch self {
                case .morning: "morning"
                case .evening: "evening"
                case .afterPrayer: "afterPrayer"
                case .beforeSleep: "beforeSleep"
                case .wakingUp: "wakingUp"
                case .eating: "eating"
                case .generalSupplications: "generalSupplications"
                }
            }
        }

        enum Action {
            case morning(DhikrListFeature.Action)
            case evening(DhikrListFeature.Action)
            case afterPrayer(DhikrListFeature.Action)
            case beforeSleep(DhikrListFeature.Action)
            case wakingUp(DhikrListFeature.Action)
            case eating(DhikrListFeature.Action)
            case generalSupplications(DhikrListFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.morning, action: \.morning) {
                DhikrListFeature()
            }

            Scope(state: \.evening, action: \.evening) {
                DhikrListFeature()
            }

            Scope(state: \.afterPrayer, action: \.afterPrayer) {
                DhikrListFeature()
            }

            Scope(state: \.beforeSleep, action: \.beforeSleep) {
                DhikrListFeature()
            }

            Scope(state: \.wakingUp, action: \.wakingUp) {
                DhikrListFeature()
            }

            Scope(state: \.eating, action: \.eating) {
                DhikrListFeature()
            }

            Scope(state: \.generalSupplications, action: \.generalSupplications) {
                DhikrListFeature()
            }
        }
    }
}
