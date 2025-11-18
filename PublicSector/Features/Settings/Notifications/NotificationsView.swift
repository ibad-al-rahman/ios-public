//
//  NotificationsView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 18/11/2025.
//

import ComposableArchitecture
import SwiftUI

struct NotificationsView: View {
    @Bindable var store: StoreOf<NotificationsFeature>

    var body: some View {
        Form {
            Section {
                Toggle("Enable Notifications", isOn: $store.notificationsEnabled)
            }

            Section {
                Toggle("Fajr", isOn: $store.fajrNotificationEnabled)
                    .disabled(store.notificationsDisabled)

                Toggle("Dhuhr", isOn: $store.dhuhrNotificationEnabled)
                    .disabled(store.notificationsDisabled)

                Toggle("Asr", isOn: $store.asrNotificationEnabled)
                    .disabled(store.notificationsDisabled)

                Toggle("Maghrib", isOn: $store.maghribNotificationEnabled)
                    .disabled(store.notificationsDisabled)

                Toggle("Ishaa", isOn: $store.ishaaNotificationEnabled)
                    .disabled(store.notificationsDisabled)
            } header: {
                Text("Prayer Notifications")
            }
        }
        .navigationTitle("Notifications")
        .onAppear {
            store.send(.view(.onAppear))
        }
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
