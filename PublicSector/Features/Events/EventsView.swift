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
        List {
            if store.isLoading {
                placeholderRows
            } else if store.filteredResults.isEmpty {
                emptyState
            } else {
                resultRows
            }
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $store.query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search events and holidays")
        )
        .onAppear { store.send(.onAppear) }
    }

    private var resultRows: some View {
        Section {
            ForEach(store.filteredResults) { result in
                resultRow(result)
            }
        } header: {
            Text(String(format: String(localized: "%lld results"), store.filteredResults.count))
        }
    }

    private func resultRow(_ result: EventsFeature.EventSearchResult) -> some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall.rawValue) {
            Text(verbatim: eventName(result))
                .environment(\.layoutDirection, eventLayoutDirection(result))
            HStack {
                Text(result.gregorian, format: .dateTime.day().month(.wide).year())
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                Spacer()
                Text(verbatim: result.hijri)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
        }
        .padding(.vertical, Spacing.extraSmall.rawValue)
    }

    @ViewBuilder
    private var emptyState: some View {
        if store.query.trimmingCharacters(in: .whitespaces).isEmpty {
            ContentUnavailableView(
                "No Events",
                systemImage: "calendar.badge.exclamationmark",
                description: Text("No events or holidays found for this year.")
            )
        } else {
            ContentUnavailableView.search(text: store.query)
        }
    }

    private var placeholderRows: some View {
        Section {
            ForEach(0 ..< 5, id: \.self) { _ in
                VStack(alignment: .leading, spacing: Spacing.extraSmall.rawValue) {
                    Text(verbatim: "Placeholder Event Name")
                    Text(verbatim: "1 January 2026")
                        .font(.footnote)
                }
                .padding(.vertical, Spacing.extraSmall.rawValue)
                .redacted(reason: .placeholder)
            }
        }
    }

    private func eventName(_ result: EventsFeature.EventSearchResult) -> String {
        if result.en != nil {
            switch Locale.current.language.languageCode?.identifier {
            case "en": return result.en ?? result.ar
            case "ar": return result.ar
            default: return result.ar
            }
        } else {
            return result.ar
        }
    }

    private func eventLayoutDirection(_ result: EventsFeature.EventSearchResult) -> LayoutDirection {
        if result.en != nil,
           Locale.current.language.languageCode?.identifier == "en" {
            return .leftToRight
        }
        return .rightToLeft
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
