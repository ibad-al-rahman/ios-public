//
//  BrandedWeeklyPrayerTimesView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 30/06/2026.
//

import Dependencies
import SwiftUI

struct BrandedWeeklyPrayerTimesView: View {
    /// Which slice of the table to render. Splitting the table lets a container
    /// pin the days column while the rest scrolls horizontally, without reading
    /// a `some View` property outside a view body (which detaches `@Environment`).
    enum Mode {
        /// The whole table, days column included (used for the shared snapshot).
        case full
        /// Only the days column, with a trailing border to butt against `.body`.
        case pinnedDaysColumn
        /// Everything except the days column.
        case body
    }

    let week: [DayInfo]
    var mode: Mode = .full

    @Environment(\.locale) private var locale

    // MARK: Layout constants
    private let headerHeight: CGFloat = 96
    private let rowHeight: CGFloat = 44
    private let weekColumnWidth: CGFloat = 96
    private let dateColumnWidth: CGFloat = 48
    private let timeColumnWidth: CGFloat = 40
    private let eventsColumnWidth: CGFloat = 150
    private let cornerRadius: CGFloat = 26

    private var hasImsak: Bool { week.contains { $0.imsak != nil } }

    private var prayers: [(prayer: Prayer, time: (DayInfo) -> Date?)] {
        var result: [(Prayer, (DayInfo) -> Date?)] = []
        if hasImsak { result.append((.imsak, { $0.imsak })) }
        result.append((.fajr, { $0.fajr }))
        result.append((.sunrise, { $0.sunrise }))
        result.append((.dhuhr, { $0.dhuhr }))
        result.append((.asr, { $0.asr }))
        result.append((.maghrib, { $0.maghrib }))
        result.append((.ishaa, { $0.ishaa }))
        return result
    }

    var body: some View {
        HStack(spacing: 0) {
            switch mode {
            case .full:
                weekColumn
                border
                scrollingColumns
            case .pinnedDaysColumn:
                weekColumn
                border
            case .body:
                scrollingColumns
            }
        }
        .dynamicTypeSize(.large)
        .fixedSize()
        .background(Color(.systemBackground))
        .clipShape(containerShape)
        .overlay(containerShape.stroke(gridLine, lineWidth: borderWidth))
    }

    /// The rounded outline of this slice. The days column and body are drawn as
    /// two adjacent views, so each rounds only its outer corners; together they
    /// read as one rounded rectangle. `.full` rounds all four.
    private var containerShape: UnevenRoundedRectangle {
        let r = cornerRadius
        switch mode {
        case .full:
            return UnevenRoundedRectangle(
                topLeadingRadius: r, bottomLeadingRadius: r,
                bottomTrailingRadius: r, topTrailingRadius: r
            )
        case .pinnedDaysColumn:
            return UnevenRoundedRectangle(topLeadingRadius: r, bottomLeadingRadius: r)
        case .body:
            return UnevenRoundedRectangle(bottomTrailingRadius: r, topTrailingRadius: r)
        }
    }

    /// Every column except the days column.
    @ViewBuilder private var scrollingColumns: some View {
        hijriColumns
        border
        gregorianColumns
        border
        prayerBlock
        border
        eventsColumn
    }

    // MARK: - Week column
    private var weekColumn: some View {
        VStack(spacing: 0) {
            headerCell(height: headerHeight, width: weekColumnWidth) {
                VStack(spacing: Spacing.extraSmall.rawValue) {
                    Text("week")
                        .font(.headline)
                    hexagon
                }
            }
            ForEach(week) { day in
                dayCell(width: weekColumnWidth, background: Color("AccentColor")) {
                    Text(day.gregorian, format: .dateTime.weekday(.wide))
                        .font(.headline)
                        .foregroundStyle(Color(.systemBackground))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
        }
    }

    private var hexagon: some View {
        let weekNumber = week.first.map {
            Calendar.current.component(.weekOfYear, from: $0.gregorian)
        }
        return ZStack {
            Image(systemName: "hexagon.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color("AccentColor"))
                .frame(width: 40, height: 40)
            if let weekNumber {
                Text(weekNumber.localizedNumber(locale: locale))
                    .foregroundStyle(Color(.systemBackground))
                    .font(numberFont(size: 24))
            }
        }
    }

    // MARK: - Hijri columns
    private var hijriColumns: some View {
        let groups = monthGroups(
            keys: week.map { MonthKey(year: $0.hijriYear, month: $0.hijriMonth) }
        )
        return dateBlock(
            yearLabel: yearLabel(first: week.first?.hijriYear, last: week.last?.hijriYear),
            groups: groups,
            monthName: { week[$0].hijriMonthName ?? "\(week[$0].hijriMonth)" },
            monthNumber: { week[$0].hijriMonth },
            dayNumber: { week[$0].hijriDay }
        )
    }

    // MARK: - Gregorian columns
    private var gregorianColumns: some View {
        let calendar = Calendar.current
        let keys = week.map { day -> MonthKey in
            let comps = calendar.dateComponents([.year, .month], from: day.gregorian)
            return MonthKey(year: comps.year ?? 0, month: comps.month ?? 0)
        }
        let groups = monthGroups(keys: keys)
        return dateBlock(
            yearLabel: yearLabel(first: keys.first?.year, last: keys.last?.year),
            groups: groups,
            monthName: { week[$0].gregorian.formatted(.dateTime.month(.wide).locale(locale)) },
            monthNumber: { calendar.component(.month, from: week[$0].gregorian) },
            dayNumber: { calendar.component(.day, from: week[$0].gregorian) }
        )
    }

    /// The year band's label. When the week stays within one year it shows that
    /// year in full; when it crosses into a new year it shows the first year in
    /// full and the second year's last two digits (e.g. `2026-27`).
    private func yearLabel(first: Int?, last: Int?) -> String {
        guard let first else { return "-" }
        guard let last, last != first else { return first.localizedNumber(locale: locale) }
        let suffix = (last % 100).localizedNumber(locale: locale, minimumDigits: 2)
        return "\(first.localizedNumber(locale: locale))-\(suffix)"
    }

    /// Shared single-column date block for Hijri and Gregorian calendars.
    ///
    /// The block is one `dateColumnWidth` wide. When the week spans two months
    /// the month labels are stacked vertically (earlier month on top, per the
    /// chronological order of `groups`), and all day numbers share one column.
    private func dateBlock(
        yearLabel: String,
        groups: [MonthGroup],
        monthName: @escaping (Int) -> String,
        monthNumber: @escaping (Int) -> Int,
        dayNumber: @escaping (Int) -> Int
    ) -> some View {
        let blockWidth = dateColumnWidth
        let monthAreaHeight = headerHeight * 2 / 3
        let monthCellHeight = monthAreaHeight / CGFloat(groups.count)
        return VStack(spacing: 0) {
            // Header: year band on top, then the month label(s) stacked.
            VStack(spacing: 0) {
                headerCell(height: headerHeight / 3, width: blockWidth) {
                    Text(verbatim: yearLabel)
                        .font(numberFont(size: 24))
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                }
                horizontalRule(width: blockWidth)
                VStack(spacing: 0) {
                    ForEach(groups) { group in
                        headerCell(height: monthCellHeight, width: blockWidth) {
                            VStack(spacing: Spacing.extraExtraSmall.rawValue) {
                                Text(verbatim: monthName(group.representativeIndex))
                                    .font(.subheadline.bold())
                                    .minimumScaleFactor(0.3)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                                Text(verbatim: monthNumber(group.representativeIndex)
                                    .localizedNumber(locale: locale))
                                    .font(numberFont(size: groups.count > 1 ? 12 : 24))
                            }
                        }
                        if group.id != groups.last?.id {
                            horizontalRule(width: blockWidth)
                        }
                    }
                }
            }
            .frame(width: blockWidth, height: headerHeight)
            .background(headerBackground)

            // Day rows: one number per row in a single column.
            ForEach(Array(week.enumerated()), id: \.element.id) { index, _ in
                dayCell(width: blockWidth) {
                    Text(verbatim: dayNumber(index).localizedNumber(locale: locale))
                        .font(numberFont(size: 32))
                }
            }
        }
    }

    // MARK: - Prayer block

    private var prayerBlock: some View {
        let columns = prayers
        // Every prayer column is two `timeColumnWidth` sub-columns plus the 1pt
        // divider between them, and adjacent columns are separated by another
        // 1pt divider. The block width must account for all of those dividers so
        // that every header row and day row lines up on the same grid.
        let columnWidth = timeColumnWidth * 2 + 1
        let blockWidth = columnWidth * CGFloat(columns.count) + CGFloat(columns.count - 1)
        return VStack(spacing: 0) {
            VStack(spacing: 0) {
                // Row 1: title spanning the whole block.
                headerCell(height: headerHeight / 3, width: blockWidth) {
                    Text(titleKey)
                        .font(.headline)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                horizontalRule(width: blockWidth)
                // Row 2: prayer names. Each name spans its column's two
                // sub-columns; a divider is overlaid at the midpoint so the
                // split aligns with the hour/minute divider in the rows below.
                HStack(spacing: 0) {
                    ForEach(Array(columns.enumerated()), id: \.offset) { index, entry in
                        headerCell(
                            height: headerHeight / 3,
                            width: columnWidth,
                            background: Color("AccentColor")
                        ) {
                            Text(entry.prayer.localizedStringKey)
                                .font(.subheadline.bold())
                                .foregroundStyle(Color(.systemBackground))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }
                        .overlay(alignment: .center) {
                            divider(height: headerHeight / 3)
                        }
                        if index != columns.count - 1 {
                            divider(height: headerHeight / 3)
                        }
                    }
                }
                horizontalRule(width: blockWidth)
                // Row 3: hour / minute unit labels. Pinned LTR so "hour" stays
                // on the left and "minute" on the right in every locale.
                HStack(spacing: 0) {
                    ForEach(Array(columns.enumerated()), id: \.offset) { index, _ in
                        unitLabel("hour_short")
                        divider(height: headerHeight / 3)
                        unitLabel("minute_short")
                        if index != columns.count - 1 {
                            divider(height: headerHeight / 3)
                        }
                    }
                }
                .environment(\.layoutDirection, .leftToRight)
            }
            .frame(width: blockWidth, height: headerHeight)
            .background(headerBackground)

            ForEach(week) { day in
                dayRowContainer {
                    HStack(spacing: 0) {
                        ForEach(Array(columns.enumerated()), id: \.offset) { index, entry in
                            timeCell(entry.time(day))
                            if index != columns.count - 1 {
                                divider(height: rowHeight)
                            }
                        }
                    }
                }
            }
        }
    }

    private var titleKey: LocalizedStringKey {
        let referenceDate = week.first?.gregorian ?? .now
        let isSummer = TimeZone.current.isDaylightSavingTime(for: referenceDate)
        return isSummer ? "summer_timing_title" : "winter_timing_title"
    }

    private func unitLabel(_ key: LocalizedStringKey) -> some View {
        Text(key)
            .font(.caption)
            .frame(width: timeColumnWidth, height: headerHeight / 3)
    }

    private func timeCell(_ date: Date?) -> some View {
        let components = date.map {
            Calendar.current.dateComponents([.hour, .minute], from: $0)
        }
        // Pinned LTR so the hour column stays on the left and the minute
        // column on the right in every locale.
        return HStack(spacing: 0) {
            Text(verbatim: hourString(from: date))
                .foregroundStyle(Color(.systemBackground))
                .frame(width: timeColumnWidth, height: rowHeight)
                .background(Color("AccentColor"))
                .font(numberFont(size: 32))
                .bold()
            divider(height: rowHeight)
            Text(verbatim: components?.minute?.localizedNumber(locale: locale, minimumDigits: 2) ?? "-")
                .frame(width: timeColumnWidth, height: rowHeight)
                .font(numberFont(size: 24))
                .bold()
        }
        .font(.title3.bold())
        .environment(\.layoutDirection, .leftToRight)
    }

    /// The hour digits only, following the locale's own clock convention
    /// (12-hour or 24-hour per the system) without any AM/PM text.
    private func hourString(from date: Date?) -> String {
        guard let date else { return "-" }
        let formatter = DateFormatter()
        formatter.locale = locale
        // "j" resolves to the locale's preferred hour field (12h or 24h);
        // the localized digits follow the locale's numbering system.
        formatter.setLocalizedDateFormatFromTemplate("j")
        let string = formatter.string(from: date)
        // Strip any AM/PM symbols the "j" template may add, keeping just the hour.
        return string
            .replacingOccurrences(of: formatter.amSymbol ?? "", with: "")
            .replacingOccurrences(of: formatter.pmSymbol ?? "", with: "")
            .trimmingCharacters(in: .whitespaces)
    }

    /// The number font: the custom ZarBold face under Arabic, otherwise the
    /// system font (bold) at the same size.
    private func numberFont(size: CGFloat) -> Font {
        if locale.language.languageCode == .arabic {
            Font.custom("ZarBold", size: size)
        } else {
            Font.system(size: size)
        }
    }

    // MARK: - Events column
    private var eventsColumn: some View {
        VStack(spacing: 0) {
            headerCell(height: headerHeight, width: eventsColumnWidth) {
                Text("holidays_and_events")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            ForEach(week) { day in
                dayCell(width: eventsColumnWidth) {
                    Text(verbatim: day.islamicEvents.map(\.string).joined(separator: "\n"))
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.6)
                }
            }
        }
    }

    // MARK: - Cell primitives
    private let borderWidth: CGFloat = 2

    private var headerBackground: Color { Color(.systemBackground) }

    private func headerCell<Content: View>(
        height: CGFloat,
        width: CGFloat,
        background: Color = Color(.systemBackground),
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(Spacing.extraSmall.rawValue)
            .frame(width: width, height: height)
            .background(background)
    }

    private func dayCell<Content: View>(
        width: CGFloat,
        background: Color = Color(.systemBackground),
        @ViewBuilder content: () -> Content
    ) -> some View {
        dayRowContainer {
            content()
                .padding(.horizontal, Spacing.extraSmall.rawValue)
                .frame(width: width, height: rowHeight)
                .background(background)
        }
    }

    /// Wraps a day row so every row gets a top divider, reproducing the table's horizontal grid lines.
    private func dayRowContainer<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            horizontalRule
            content()
        }
    }

    private var gridLine: Color { Color(.separator) }

    /// A full-width 1pt horizontal line between rows.
    private var horizontalRule: some View {
        Rectangle().fill(gridLine).frame(height: 1)
    }

    /// A 1pt horizontal line of a fixed width, used inside header blocks.
    private func horizontalRule(width: CGFloat) -> some View {
        Rectangle().fill(gridLine).frame(width: width, height: 1)
    }

    /// A 1pt vertical line separating cells; height matches the row/header it sits in.
    private func divider(height: CGFloat) -> some View {
        Rectangle().fill(gridLine).frame(width: 1, height: height)
    }

    /// The heavier vertical rule that separates the top-level column groups.
    private var border: some View {
        Rectangle().fill(gridLine).frame(width: borderWidth)
    }
}

// MARK: - Month grouping
private struct MonthKey: Equatable {
    let year: Int
    let month: Int
}

private struct MonthGroup: Identifiable {
    let id: Int
    let range: Range<Int>
    /// Index into `week` used to read the month's name/number.
    var representativeIndex: Int { range.lowerBound }
}

/// Collapses consecutive equal month keys into contiguous groups (max 2 for a 7-day week).
private func monthGroups(keys: [MonthKey]) -> [MonthGroup] {
    var groups: [MonthGroup] = []
    var start = 0
    for index in 1...max(keys.count - 1, 0) where index < keys.count {
        if keys[index] != keys[start] {
            groups.append(MonthGroup(id: groups.count, range: start..<index))
            start = index
        }
    }
    if !keys.isEmpty {
        groups.append(MonthGroup(id: groups.count, range: start..<keys.count))
    }
    return groups
}

// MARK: - Preview helper
extension BrandedWeeklyPrayerTimesView {
    @Dependency(\.miqatService) static var miqatService

    static func previewWeek() -> [DayInfo] {
        let calendar = Calendar.current
        let now = Date.now
        let weekday = calendar.component(.weekday, from: now)
        let daysBack = weekday % 7
        guard let saturday = calendar.date(byAdding: .day, value: -daysBack, to: now) else { return [] }
        let tzOffset = TimeZone.current.secondsFromGMT()
        return (0..<7).compactMap { i in
            guard let dayDate = calendar.date(byAdding: .day, value: i, to: saturday) else { return nil }
            let ts = dayDate.timeIntervalSince1970 + TimeInterval(tzOffset)
            return DayInfo(from: miqatService.getMiqatData(ts, .darElFatwa(.beirut)))
        }
    }
}

#Preview {
    BrandedWeeklyPrayerTimesView(week: BrandedWeeklyPrayerTimesView.previewWeek())
}

#Preview {
    BrandedWeeklyPrayerTimesView(week: BrandedWeeklyPrayerTimesView.previewWeek())
        .arabicEnvironment()
}
