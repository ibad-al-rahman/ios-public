//
//  AppView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import IbadRemoteConfig
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        content
            .ifLet(store.appearance.colorScheme) { colorScheme, view in
                view.environment(\.colorScheme, colorScheme)
            }
            .onAppear { store.send(.onAppear) }
    }

    var content: some View {
        TabView(selection: $store.selectedTab) {
            prayerTimesScreen
            eventsScreen
            adhkarScreen
                .featureFlagged(.adhkarScreen)
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
                systemImage: "clock"
            )
        }
        .tag(AppFeature.Tab.prayerTimes)
        .environment(\.symbolVariants, store.selectedTab == .prayerTimes ? .fill : .none)
    }

    var eventsScreen: some View {
        NavigationStack {
            EventsView(store: store.scope(
                state: \.events,
                action: \.dependent.events
            ))
        }
        .tabItem {
            Label(
                AppFeature.Tab.events.localizedStringKey,
                systemImage: "calendar.badge.clock"
            )
        }
        .tag(AppFeature.Tab.events)
    }

    var adhkarScreen: some View {
        AdhkarView(store: store.scope(
            state: \.adhkar,
            action: \.dependent.adhkar
        ))
        .tabItem {
            Label(
                AppFeature.Tab.adhkar.localizedStringKey,
                systemImage: "book.pages"
            )
        }
        .tag(AppFeature.Tab.adhkar)
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
        case .events: "Events"
        case .settings: "Settings"
        case .adhkar: "Adhkar"
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
