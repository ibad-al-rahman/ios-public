//
//  NotificationsView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/03/2026.
//

import ComposableArchitecture
import SwiftUI

struct NotificationsView: View {
    @Bindable var store: StoreOf<NotificationsFeature>

    var body: some View {
        Form {
            Section {
                Toggle("enable_notifications", isOn: $store.notificationsEnabled)
            }

            Section {
                Toggle("fajr", isOn: $store.fajrNotificationEnabled)
                    .disabled(store.notificationsDisabled)

                Toggle("dhuhr", isOn: $store.dhuhrNotificationEnabled)
                    .disabled(store.notificationsDisabled)

                Toggle("asr", isOn: $store.asrNotificationEnabled)
                    .disabled(store.notificationsDisabled)

                Toggle("maghrib", isOn: $store.maghribNotificationEnabled)
                    .disabled(store.notificationsDisabled)

                Toggle("ishaa", isOn: $store.ishaaNotificationEnabled)
                    .disabled(store.notificationsDisabled)
            } header: {
                Text("prayer_notifications")
            }
        }
        .navigationTitle("notifications")
        .onAppear {
            store.send(.view(.onAppear))
        }
        .alert($store.scope(
            state: \.destination?.alert,
            action: \.dependent.destination.alert
        ))
    }
}

#Preview {
    NavigationStack {
        NotificationsView(store: Store(
            initialState: NotificationsFeature.State(),
            reducer: NotificationsFeature.init
        ))
    }
}

#Preview {
    NavigationStack {
        NotificationsView(store: Store(
            initialState: NotificationsFeature.State(),
            reducer: NotificationsFeature.init
        ))
        .arabicEnvironment()
    }
}
