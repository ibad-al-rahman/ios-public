//
//  View+Snapshot.swift
//  PublicSector
//
//  Created by Hamza Jadid on 30/06/2026.
//

import SwiftUI
import UIKit

extension View {
    /// Renders the view to a `UIImage` using `ImageRenderer`.
    ///
    /// `ImageRenderer` renders detached from the view hierarchy and does not
    /// inherit the app's SwiftUI environment, so the current `locale` and
    /// `layoutDirection` are injected explicitly to keep the snapshot in sync
    /// with what the user sees on screen (RTL mirroring, localized numerals).
    @MainActor
    func snapshot(
        locale: Locale = .current,
        layoutDirection: LayoutDirection = UIView.userInterfaceLayoutDirection(
            for: .unspecified
        ) == .rightToLeft ? .rightToLeft : .leftToRight
    ) -> UIImage {
        let content = self
            .environment(\.locale, locale)
            .environment(\.layoutDirection, layoutDirection)
        let renderer = ImageRenderer(content: content)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }
}
