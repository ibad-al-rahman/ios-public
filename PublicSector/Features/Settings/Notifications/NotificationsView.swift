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
                Group {
                    Toggle("fajr", isOn: $store.prayerTimesNotifications.fajr)
                    Toggle("dhuhr", isOn: $store.prayerTimesNotifications.dhuhr)
                    Toggle("asr", isOn: $store.prayerTimesNotifications.asr)
                    Toggle("maghrib", isOn: $store.prayerTimesNotifications.maghrib)
                    Toggle("ishaa", isOn: $store.prayerTimesNotifications.ishaa)
                }
                .disabled(store.notificationsDisabled)
            } header: {
                Text("prayer_notifications")
            }

            Section {
                Group {
                    Toggle("morning_adhkar", isOn: $store.adhkarNotifications.morningEnabled)
                    DatePicker(
                        "time",
                        selection: $store.adhkarNotifications.morningTime.date,
                        displayedComponents: [.hourAndMinute]
                    )
                    .disabled(!store.adhkarNotifications.morningEnabled)
                }
                .disabled(store.notificationsDisabled)
            } header: {
                Text("morning_adhkar_notification")
            }

            Section {
                Group {
                    Toggle("evening_adhkar", isOn: $store.adhkarNotifications.eveningEnabled)
                    DatePicker(
                        "time",
                        selection: $store.adhkarNotifications.eveningTime.date,
                        displayedComponents: [.hourAndMinute]
                    )
                    .disabled(!store.adhkarNotifications.eveningEnabled)
                }
                .disabled(store.notificationsDisabled)
            } header: {
                Text("evening_adhkar_notification")
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
