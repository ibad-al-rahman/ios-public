//
//  AppEntryFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/12/2024.
//

import ComposableArchitecture

@Reducer
struct AppEntryFeature {
    @ObservableState
    enum State: Equatable {
        case app(AppFeature.State)
        case startup(StartupFeature.State)
    }

    enum Action {
        case app(AppFeature.Action)
        case startup(StartupFeature.Action)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
            .ifCaseLet(\.app, action: \.app) { AppFeature() }
            .ifCaseLet(\.startup, action: \.startup) { StartupFeature() }
    }
}
