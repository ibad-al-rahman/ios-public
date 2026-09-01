//
//  AdhkarFeature+Destination.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import ComposableArchitecture

extension AdhkarFeature {
    @Reducer
    struct Destination {
        enum State: Identifiable, Equatable {
            case tour(AdhkarTourFeature.State)
            case istikhara(IstikharaFeature.State)

            var id: AnyHashable {
                switch self {
                case .tour: "tour"
                case .istikhara: "istikhara"
                }
            }
        }

        enum Action {
            case tour(AdhkarTourFeature.Action)
            case istikhara(IstikharaFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.tour, action: \.tour) {
                AdhkarTourFeature()
            }
            Scope(state: \.istikhara, action: \.istikhara) {
                IstikharaFeature()
            }
        }
    }
}
