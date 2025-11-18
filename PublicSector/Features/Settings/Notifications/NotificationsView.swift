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
                Text("Notification settings will be configured here")
                    .foregroundColor(.secondary)
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
