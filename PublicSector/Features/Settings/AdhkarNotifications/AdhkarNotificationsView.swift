//
//  AdhkarNotificationsView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/03/2026.
//

import ComposableArchitecture
import SwiftUI

struct AdhkarNotificationsView: View {
    @Bindable var store: StoreOf<AdhkarNotificationsFeature>
    @Environment(\.locale) private var locale

    private var isArabic: Bool {
        locale.language.languageCode?.identifier == "ar"
    }

    var body: some View {
        Form {
            notificationSection(
                title: isArabic ? "ذكر اليوم" : "Daily dhikr",
                footer: isArabic ? "ذكر عشوائي يومياً من جميع الأذكار." : "A random daily dhikr from all categories.",
                systemImage: "clock",
                isEnabled: store.dailyEnabled,
                time: store.dailyTime,
                onToggle: { store.send(.view(.onDailyToggle($0))) },
                onTimeChanged: { store.send(.view(.onDailyTimeChanged($0))) }
            )

            notificationSection(
                title: isArabic ? "أذكار الصباح" : "Morning adhkar",
                footer: isArabic ? "ذكر من أذكار الصباح في الوقت المحدد." : "A morning dhikr at the selected time.",
                systemImage: "sunrise",
                isEnabled: store.morningEnabled,
                time: store.morningTime,
                onToggle: { store.send(.view(.onMorningToggle($0))) },
                onTimeChanged: { store.send(.view(.onMorningTimeChanged($0))) }
            )

            notificationSection(
                title: isArabic ? "أذكار المساء" : "Evening adhkar",
                footer: isArabic ? "ذكر من أذكار المساء في الوقت المحدد." : "An evening dhikr at the selected time.",
                systemImage: "sunset",
                isEnabled: store.eveningEnabled,
                time: store.eveningTime,
                onToggle: { store.send(.view(.onEveningToggle($0))) },
                onTimeChanged: { store.send(.view(.onEveningTimeChanged($0))) }
            )
        }
        .disabled(store.isLoading)
        .navigationTitle(isArabic ? "تذكيرات الأذكار" : "Adhkar Reminders")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.send(.view(.onAppear)) }
    }

    @ViewBuilder
    private func notificationSection(
        title: String,
        footer: String,
        systemImage: String,
        isEnabled: Bool,
        time: Date,
        onToggle: @escaping (Bool) -> Void,
        onTimeChanged: @escaping (Date) -> Void
    ) -> some View {
        Section {
            Toggle(isOn: Binding(get: { isEnabled }, set: onToggle)) {
                Label(title, systemImage: systemImage)
            }

            if isEnabled {
                DatePicker(
                    isArabic ? "الوقت" : "Time",
                    selection: Binding(get: { time }, set: onTimeChanged),
                    displayedComponents: .hourAndMinute
                )
            }
        } footer: {
            if isEnabled {
                Text(footer)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AdhkarNotificationsView(store: Store(
            initialState: AdhkarNotificationsFeature.State(),
            reducer: AdhkarNotificationsFeature.init
        ))
    }
}
