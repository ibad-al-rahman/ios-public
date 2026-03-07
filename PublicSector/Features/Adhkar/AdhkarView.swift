//
//  AdhkarView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 22/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct AdhkarView: View {
    @Bindable var store: StoreOf<AdhkarFeature>
    @Environment(\.locale) private var locale

    private var isArabic: Bool {
        locale.language.languageCode?.identifier == "ar"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationRowView(isArabic ? "أذكار الصباح" : "Morning adhkar", systemName: "sun.horizon")
                        .onTapGesture { store.send(.view(.onTapMorning)) }
                    NavigationRowView(isArabic ? "أذكار المساء" : "Evening adhkar", systemName: "moon.stars")
                        .onTapGesture { store.send(.view(.onTapEvening)) }
                    NavigationRowView(isArabic ? "أذكار بعد الصلاة" : "After prayer", systemName: "hands.sparkles")
                        .onTapGesture { store.send(.view(.onTapAfterPrayer)) }
                    NavigationRowView(isArabic ? "أذكار النوم" : "Before sleep", systemName: "bed.double")
                        .onTapGesture { store.send(.view(.onTapBeforeSleep)) }
                    NavigationRowView(isArabic ? "أذكار الاستيقاظ" : "Waking up", systemName: "alarm")
                        .onTapGesture { store.send(.view(.onTapWakingUp)) }
                    NavigationRowView(isArabic ? "أذكار الطعام والشراب" : "Eating & drinking", systemName: "fork.knife")
                        .onTapGesture { store.send(.view(.onTapEating)) }
                    NavigationRowView(isArabic ? "الأدعية العامة" : "General supplications", systemName: "heart.text.square")
                        .onTapGesture { store.send(.view(.onTapGeneralSupplications)) }
                } header: {
                    Spacer(minLength: Spacing.small)
                }
            }
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.morning,
                    action: \.dependent.destination.morning
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.evening,
                    action: \.dependent.destination.evening
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.afterPrayer,
                    action: \.dependent.destination.afterPrayer
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.beforeSleep,
                    action: \.dependent.destination.beforeSleep
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.wakingUp,
                    action: \.dependent.destination.wakingUp
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.eating,
                    action: \.dependent.destination.eating
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.generalSupplications,
                    action: \.dependent.destination.generalSupplications
                ),
                destination: { DhikrListView(store: $0) }
            )
            .navigationTitle("Adhkar")
        }
    }
}

#Preview {
    AdhkarView(store: Store(
        initialState: AdhkarFeature.State(),
        reducer: AdhkarFeature.init
    ))
}

#Preview {
    AdhkarView(store: Store(
        initialState: AdhkarFeature.State(),
        reducer: AdhkarFeature.init
    ))
    .arabicEnvironment()
}
