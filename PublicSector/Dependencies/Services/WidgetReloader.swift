//
//  WidgetReloader.swift
//  PublicSector
//
//  Created by Hamza Jadid on 21/07/2026.
//

import ComposableArchitecture
import WidgetKit

@DependencyClient
struct WidgetReloader: Sendable {
    /// Reloads all widget timelines (prayer times + hijri date) so they recompute
    /// from the latest persisted calculation method.
    var reloadAll: @Sendable () -> Void
}

extension WidgetReloader: DependencyKey {
    static let liveValue = WidgetReloader(
        reloadAll: { WidgetCenter.shared.reloadAllTimelines() }
    )
}

extension WidgetReloader {
    static let testValue = WidgetReloader()
}

extension DependencyValues {
    var widgetReloader: WidgetReloader {
        get { self[WidgetReloader.self] }
        set { self[WidgetReloader.self] = newValue }
    }
}
