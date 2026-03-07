//
//  DhikrListView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 06/03/2026.
//

import ComposableArchitecture
import SwiftUI

struct DhikrListView: View {
    let store: StoreOf<DhikrListFeature>

    var body: some View {
        Group {
            if store.viewMode == .list {
                listView
            } else {
                journeyView
            }
        }
        .sheet(item: Binding(
            get: { store.selectedDhikrInfo },
            set: { _ in store.send(.view(.onInfoDismissed)) }
        )) { dhikr in
            DhikrInfoSheet(dhikr: dhikr)
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.view(.onToggleViewMode), animation: .spring(duration: 0.4))
                } label: {
                    Image(systemName: store.viewMode == .list ? "play.rectangle" : "list.bullet")
                }
            }
        }
    }

    // MARK: - Mode 1: List

    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(store.adhkar) { dhikr in
                        let remaining = store.remaining[dhikr.id] ?? dhikr.count
                        let isDone = remaining == 0

                        Button {
                            store.send(.view(.onDhikrTapped(dhikr)), animation: .spring(duration: 0.3))
                        } label: {
                            listRow(dhikr: dhikr, remaining: remaining, isDone: isDone)
                        }
                        .buttonStyle(.plain)
                        .disabled(isDone)
                        .contextMenu {
                            Button {
                                store.send(.view(.onDhikrReset(dhikr)), animation: .spring(duration: 0.3))
                            } label: {
                                Label("Reset", systemImage: "arrow.counterclockwise")
                            }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            if dhikr.hasInfo {
                                Button {
                                    store.send(.view(.onInfoTapped(dhikr)))
                                } label: {
                                    Image(systemName: "info.circle")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .padding(Spacing.large)
                                }
                            }
                        }
                    }
                } header: {
                    overallProgressRing
                        .padding(.vertical, Spacing.medium)
                        .frame(maxWidth: .infinity)
                        .background(.bar)
                }
            }
            .padding(.bottom, Spacing.large)
        }
    }

    private func listRow(dhikr: Dhikr, remaining: Int, isDone: Bool) -> some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack(alignment: .top, spacing: Spacing.medium) {
                Text(dhikr.ar)
                    .font(.body)
                    .lineSpacing(Spacing.small)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(isDone ? .tertiary : .primary)
                    .strikethrough(isDone, color: .secondary)

                countBadge(remaining: remaining, isDone: isDone)
                    .frame(minWidth: 36, alignment: .trailing)
            }

            progressBar(remaining: remaining, total: dhikr.count, isDone: isDone)
        }
        .padding(Spacing.large)
        .contentShape(Rectangle())
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.extraSmall)
    }

    // MARK: - Mode 2: Journey

    private var journeyView: some View {
        VStack(spacing: 0) {
            if let dhikr = store.currentJourneyDhikr {
                let remaining = store.remaining[dhikr.id] ?? dhikr.count
                let isDone = remaining == 0
                let isLast = store.journeyIndex == store.adhkar.count - 1

                // Progress indicator
                HStack {
                    if dhikr.hasInfo {
                        Button {
                            store.send(.view(.onInfoTapped(dhikr)))
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Color.clear
                    }

                    Spacer()

                    Text("\(store.journeyIndex + 1) / \(store.adhkar.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Color.clear
                }
                .padding(.horizontal, Spacing.large)

                // Arabic text
                ScrollView {
                    Text(dhikr.ar)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .lineSpacing(Spacing.medium)
                        .padding(.horizontal, Spacing.large)
                        .foregroundStyle(isDone ? .tertiary : .primary)
                        .frame(maxWidth: .infinity)
                }
                .scrollBounceBehavior(.basedOnSize)

                Spacer(minLength: Spacing.medium)

                // Tap button
                Button {
                    store.send(.view(.onDhikrTapped(dhikr)), animation: .spring(duration: 0.3))
                } label: {
                    ZStack {
                        Circle()
                            .fill(isDone ? Color.green.opacity(0.15) : Color.accentColor.opacity(0.1))
                            .frame(width: 120, height: 120)

                        if isDone {
                            Image(systemName: "checkmark")
                                .font(.system(size: 36, weight: .light))
                                .foregroundStyle(.green)
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Text("\(remaining)")
                                .font(.system(size: 40, weight: .light, design: .rounded))
                                .foregroundStyle(.primary)
                                .contentTransition(.numericText(countsDown: true))
                        }
                    }
                }
                .buttonStyle(.plain)
                .disabled(isDone)

                Spacer()

                // Navigation
                VStack(spacing: Spacing.medium) {
                    if !isDone && !isLast {
                        Button {
                            store.send(.view(.onJourneyNext), animation: .spring(duration: 0.4))
                        } label: {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }

                    HStack(spacing: Spacing.medium) {
                        Button {
                            store.send(.view(.onJourneyPrevious), animation: .spring(duration: 0.4))
                        } label: {
                            Text("Back")
                                .font(.body.weight(.medium))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color(.separator), lineWidth: 1)
                                }
                        }
                        .buttonStyle(.plain)
                        .disabled(store.journeyIndex == 0)

                        Button {
                            store.send(.view(.onJourneyNext), animation: .spring(duration: 0.4))
                        } label: {
                            Text("Next")
                                .font(.body.weight(.medium))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(isDone ? Color.accentColor : .clear)
                                .foregroundStyle(isDone ? .white : .primary)
                                .overlay {
                                    if !isDone {
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color(.separator), lineWidth: 1)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                        .disabled(isLast)
                    }
                }
                .padding(.horizontal, Spacing.large)
                .padding(.bottom, Spacing.large)
            }
        }
    }

    private var overallProgressRing: some View {
        let progress = store.overallProgress
        let percent = Int(progress * 100)
        let allDone = progress >= 1.0
        let done = store.adhkar.filter { (store.remaining[$0.id] ?? $0.count) == 0 }.count

        return HStack(spacing: Spacing.large) {
            ZStack {
                Circle()
                    .stroke(Color(.systemFill), lineWidth: 6)
                    .frame(width: 72, height: 72)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        allDone ? Color.green : Color.accentColor,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 72, height: 72)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(duration: 0.5), value: progress)

                if allDone {
                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.green)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text("\(percent)%")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())
                }
            }
            .animation(.spring(duration: 0.3), value: allDone)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(done) of \(store.adhkar.count) adhkar")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)

                Text("complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, Spacing.large)
    }

    // MARK: - Shared helpers

    @ViewBuilder
    private func countBadge(remaining: Int, isDone: Bool) -> some View {
        Group {
            if isDone {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.green)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text("×\(remaining)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor, in: Capsule())
                    .contentTransition(.numericText(countsDown: true))
            }
        }
        .animation(.spring(duration: 0.3), value: isDone)
    }

    private func progressBar(remaining: Int, total: Int, isDone: Bool) -> some View {
        let progress = total > 1 ? Double(total - remaining) / Double(total) : (isDone ? 1.0 : 0.0)

        return GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemFill))
                    .frame(height: 3)

                Capsule()
                    .fill(isDone ? Color.green : Color.accentColor)
                    .frame(width: geo.size.width * progress, height: 3)
            }
        }
        .frame(height: 3)
        .animation(.spring(duration: 0.3), value: progress)
    }

    private var title: String {
        switch store.category {
        case .morning: "أذكار الصباح"
        case .evening: "أذكار المساء"
        case .afterPrayer: "أذكار بعد الصلاة"
        case .beforeSleep: "أذكار النوم"
        case .wakingUp: "أذكار الاستيقاظ"
        case .eating: "أذكار الطعام والشراب"
        case .generalSupplications: "الأدعية العامة"
        }
    }
}

// MARK: - Info Sheet

private struct DhikrInfoSheet: View {
    let dhikr: Dhikr

    var body: some View {
        NavigationStack {
            List {
                if let source = dhikr.source {
                    Section {
                        Text(verbatim: source)
                            .font(.body)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                    } header: {
                        Text(verbatim: "المصدر")
                    }
                }

                if let narrator = dhikr.narrator {
                    Section {
                        Text(verbatim: narrator)
                            .font(.body)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                    } header: {
                        Text(verbatim: "الراوي")
                    }
                }

                if let virtue = dhikr.virtue {
                    Section {
                        Text(verbatim: virtue)
                            .font(.body)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                    } header: {
                        Text(verbatim: "الفضل")
                    }
                }
            }
            .navigationTitle(Text(verbatim: "معلومات الذكر"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    NavigationStack {
        DhikrListView(store: Store(
            initialState: DhikrListFeature.State(category: .morning),
            reducer: DhikrListFeature.init
        ))
    }
}

#Preview {
    NavigationStack {
        DhikrListView(store: Store(
            initialState: DhikrListFeature.State(category: .morning),
            reducer: DhikrListFeature.init
        ))
    }
    .arabicEnvironment()
}
