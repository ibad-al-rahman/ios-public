//
//  SettingsView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import IbadRemoteConfig
import SwiftUI

struct SettingsView: View {
    @Bindable var store: StoreOf<SettingsFeature>

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationRowView("donate", systemName: "heart")
                        .onTapGesture { store.send(.onTapDonate) }
                } header: {
                    Spacer(minLength: Spacing.small)
                }

                Section {
                    NavigationRowView("notifications", systemName: "app.badge")
                        .onTapGesture { store.send(.onTapNotifications) }
                }
                .featureFlagged(.prayerTimesNotifications)

                displaySection

                Section {
                    NavigationRowView("help", systemName: "questionmark.circle")
                        .onTapGesture { store.send(.onTapHelp) }

                    Label("rate_us", systemImage: "star")
                        .foregroundStyle(.primary, .primary)
                        .onTapGesture { store.send(.onTapRateUs) }

                    ShareLink(item: store.inviteFriendsShareContent) {
                        Label("invite_friends", systemImage: "paperplane")
                            .foregroundStyle(.primary, .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.appearance,
                    action: \.dependent.destination.appearance
                ),
                destination: { AppearanceView(store: $0) }
            )
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.notifications,
                    action: \.dependent.destination.notifications
                ),
                destination: { NotificationsView(store: $0) }
            )
            .sheet(
                item: $store.scope(
                    state: \.destination?.help,
                    action: \.dependent.destination.help
                ),
                content: { HelpView(store: $0) }
            )
            .navigationTitle("settings")
        }
        .onAppear { store.send(.onAppear) }
    }

    private var displaySection: some View {
        Section("display") {
            NavigationRowView("appearance", systemName: "circle.lefthalf.filled")
                .onTapGesture { store.send(.onTapAppearance) }

            NavigationRowView("language", systemName: "a.square")
                .onTapGesture { store.send(.onTapLanguage) }
        }
    }
}

#Preview {
    SettingsView(store: Store(
        initialState: SettingsFeature.State(),
        reducer: SettingsFeature.init
    ))
}

#Preview {
    SettingsView(store: Store(
        initialState: SettingsFeature.State(),
        reducer: SettingsFeature.init
    ))
    .arabicEnvironment()
}
