//
//  AppView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        content
            .environment(\.locale, store.language.locale)
            .ifLet(store.appearance.colorScheme) { colorScheme, view in
                view.environment(\.colorScheme, colorScheme)
            }
            .ifLet(store.language.layoutDirection) { direction, view in
                view.environment(\.layoutDirection, direction)
            }
    }

    var content: some View {
        TabView(selection: $store.selectedTab) {
            prayerTimesScreen
            settingsScreen
        }
    }

    var prayerTimesScreen: some View {
        PrayerTimesView(store: store.scope(
            state: \.prayerTimes,
            action: \.dependent.prayerTimes
        ))
        .tabItem {
            Label(
                AppFeature.Tab.prayerTimes.localizedStringKey,
                systemImage: "calendar.badge.clock"
            )
        }
        .tag(AppFeature.Tab.prayerTimes)
    }

    var settingsScreen: some View {
        SettingsView(store: store.scope(
            state: \.settings,
            action: \.dependent.settings
        ))
        .tabItem {
            Label(
                AppFeature.Tab.settings.localizedStringKey,
                systemImage: "gear"
            )
        }
        .tag(AppFeature.Tab.settings)
    }
}

extension AppFeature.Tab {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .prayerTimes: "Prayer Times"
        case .settings: "Settings"
        }
    }
}

#Preview {
    AppView(store: Store(
        initialState: AppFeature.State(),
        reducer: AppFeature.init
    ))
}

#Preview {
    AppView(store: Store(
        initialState: AppFeature.State(),
        reducer: AppFeature.init
    ))
    .arabicEnvironment()
}
