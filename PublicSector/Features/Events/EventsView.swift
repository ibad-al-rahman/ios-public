//
//  EventsView.swift
//  PublicSector
//
//  Created by May Chehab on 05/03/2026.
//

import ComposableArchitecture
import SwiftUI

struct EventsView: View {
    @Bindable var store: StoreOf<EventsFeature>

    var body: some View {
        content
            .navigationTitle("events")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $store.query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("search_events_holidays")
            )
            .onAppear { store.send(.onAppear) }
    }

    @ViewBuilder
    private var content: some View {
        List {
            yearPicker
            if store.filteredEvents.isEmpty {
                emptyState
            } else {
                eventRows
            }
        }
    }

    private var yearPicker: some View {
        HStack {
            Button {
                store.year -= 1
            } label: {
                Image(systemName: "chevron.backward")
            }
            .disabled(!store.canDecrementYear)

            Spacer()

            Text(store.year, format: .number.grouping(.never))
                .font(.headline)
                .monospacedDigit()

            Spacer()

            Button {
                store.year += 1
            } label: {
                Image(systemName: "chevron.forward")
            }
            .disabled(!store.canIncrementYear)
        }
        .buttonStyle(.borderless)
    }

    private var eventRows: some View {
        Section {
            ForEach(store.filteredEvents, id: \.event) { event in
                VStack(alignment: .leading, spacing: Spacing.extraSmall.rawValue) {
                    Text(event.event.string)
                    HStack {
                        Text(event.gregorianDate, format: .dateTime.day().month(.wide).year())
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                        Spacer()
                        if let formattedHijriDate = event.hijriDate.formatted {
                            Text(formattedHijriDate)
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                        }
                    }
                }
                .padding(.vertical, Spacing.extraSmall.rawValue)
            }
        } header: {
            Text(String(format: String(localized: "search_results_count"), store.filteredEvents.count))
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        Group {
            if store.query.trimmingCharacters(in: .whitespaces).isEmpty {
                ContentUnavailableView(
                    "no_events",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("no_events_for_year")
                )
            } else {
                ContentUnavailableView.search(text: store.query)
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        EventsView(store: Store(
            initialState: EventsFeature.State(),
            reducer: EventsFeature.init
        ))
    }
}

#Preview {
    NavigationStack {
        EventsView(store: Store(
            initialState: EventsFeature.State(),
            reducer: EventsFeature.init
        ))
    }
    .arabicEnvironment()
}
