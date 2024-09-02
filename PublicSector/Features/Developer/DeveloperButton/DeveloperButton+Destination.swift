//
//  DeveloperButton+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture

extension DeveloperButtonFeature {
    @Reducer
    struct Destination {
        enum State: Equatable, Identifiable {
            case developerMenu(DeveloperMenuFeature.State)

            var id: AnyHashable {
                switch self {
                case .developerMenu:
                    "dev-menu"
                }
            }
        }

        enum Action {
            case developerMenu(DeveloperMenuFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(
                state: \.developerMenu,
                action: \.developerMenu
            ) {
                DeveloperMenuFeature()
            }
        }
    }
}
