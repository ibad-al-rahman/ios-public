//
//  LocationSearchFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 27/03/2026.
//

@preconcurrency import MapKit
import ComposableArchitecture

@Reducer
struct LocationSearchFeature {
    @Dependency(\.uuid) private var uuid
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.locationSearch) private var locationSearch

    @ObservableState
    struct State: Equatable {
        var query: String = ""
        var completions: [LocationCompletion] = []
        var resolvedCoordinate: ResolvedCoordinate?
        var pendingLocationName: String?
    }

    struct LocationCompletion: Equatable, Identifiable, Sendable {
        let id: UUID
        let title: String
        let subtitle: String
        let completion: MKLocalSearchCompletion

        static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    }

    struct ResolvedCoordinate: Equatable {
        let latitude: Double
        let longitude: Double
    }

    enum CancelID { case search }

    enum Action: BaseAction, BindableAction {
        case view(ViewAction)
        case reducer(ReducerAction)
        case delegate(DelegateAction)
        case dependent(DependentAction)
        case binding(BindingAction<State>)

        enum ViewAction {
            case onAppear
            case onCompletionTapped(LocationCompletion)
        }

        @CasePathable
        enum ReducerAction {
            case completionsUpdated([MKLocalSearchCompletion])
            case coordinateResolved(CLLocationCoordinate2D?)
        }

        @CasePathable
        enum DelegateAction {
            case didSelectLocation(Settings.SelectedLocation)
        }

        @CasePathable
        enum DependentAction { }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case let .view(.onCompletionTapped(completion)):
                state.pendingLocationName = completion.title
                return .concatenate(
                    .run { [completion] send in
                        let coordinate = await locationSearch.resolve(completion.completion)
                        await send(.reducer(.coordinateResolved(coordinate)))
                    },
                    .run { _ in await dismiss() }
                )

            case let .reducer(.completionsUpdated(completions)):
                state.completions = completions.map {
                    LocationCompletion(id: uuid(), title: $0.title, subtitle: $0.subtitle, completion: $0)
                }
                return .none

            case let .reducer(.coordinateResolved(coordinate)):
                state.resolvedCoordinate = coordinate.map {
                    ResolvedCoordinate(latitude: $0.latitude, longitude: $0.longitude)
                }
                let pendingName = state.pendingLocationName
                state.pendingLocationName = nil
                if let coordinate, let name = pendingName {
                    return .send(.delegate(.didSelectLocation(Settings.SelectedLocation(
                        name: name,
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    ))))
                }
                return .none

            case .binding(\.query):
                guard !state.query.isEmpty else {
                    state.completions = []
                    state.resolvedCoordinate = nil
                    return .cancel(id: CancelID.search)
                }
                let query = state.query
                return .run { send in
                    for await completions in locationSearch.completions(query) {
                        await send(.reducer(.completionsUpdated(completions)))
                    }
                }
                .cancellable(id: CancelID.search, cancelInFlight: true)

            default:
                return .none
            }
        }
    }
}

