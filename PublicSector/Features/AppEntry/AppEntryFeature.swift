//
//  AppEntryFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/12/2024.
//

import ComposableArchitecture
import IbadRemoteConfig

@Reducer
struct AppEntryFeature {
    @Dependency(\.remoteConfig) private var remoteConfig

    @ObservableState
    enum State: Equatable {
        case app(AppFeature.State)
        case startup(StartupFeature.State)
        case forceUpdate(ForceUpdateFeature.State)
    }

    enum Action {
        case onAppear
        case deepLink(RootRoute)

        case app(AppFeature.Action)
        case startup(StartupFeature.Action)
        case forceUpdate(ForceUpdateFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if remoteConfig.isFlagEnabled(key: .forceUpdate) {
                    state = .forceUpdate(ForceUpdateFeature.State())
                } else {
                    state = .app(AppFeature.State())
                }
                return .none

            case let .deepLink(route):
                // A forced update takes precedence over any deep link.
                guard !remoteConfig.isFlagEnabled(key: .forceUpdate) else { return .none }

                // Make sure we're in the app before routing; a link can arrive while
                // still on the startup screen.
                if case .app = state {} else {
                    state = .app(AppFeature.State())
                }
                return .send(.app(.reducer(.deepLink(route))))

            default:
                return .none
            }
        }
        .ifCaseLet(\.app, action: \.app) { AppFeature() }
        .ifCaseLet(\.startup, action: \.startup) { StartupFeature() }
        .ifCaseLet(\.forceUpdate, action: \.forceUpdate) { ForceUpdateFeature() }
    }
}
