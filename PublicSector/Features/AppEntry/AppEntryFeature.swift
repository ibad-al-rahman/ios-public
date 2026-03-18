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

            default:
                return .none
            }
        }
        .ifCaseLet(\.app, action: \.app) { AppFeature() }
        .ifCaseLet(\.startup, action: \.startup) { StartupFeature() }
        .ifCaseLet(\.forceUpdate, action: \.forceUpdate) { ForceUpdateFeature() }
    }
}
