//
//  Spacing.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import SwiftUI

enum Spacing: CGFloat {
    /// none = 0
    case none = 0
    /// extraExtraSmall = 2
    case extraExtraSmall = 2
    /// extraSmall = 4
    case extraSmall = 4
    /// small = 6
    case small = 6
    /// standard = 8
    case standard = 8
    /// medium = 12
    case medium = 12
    /// large = 16
    case large = 16
    /// extraLarge = 24
    case extraLarge = 24
    /// extraExtraLarge = 32
    case extraExtraLarge = 32
    /// giant = 48
    case giant = 48
    /// extraGiant = 80
    case extraGiant = 80
}

extension View {
    func padding(_ padding: Spacing) -> some View {
        self.padding(padding.rawValue)
    }

    func padding(_ edges: Edge.Set = .all, _ padding: Spacing) -> some View {
        self.padding(edges, padding.rawValue)
    }

    func lineSpacing(_ lineSpacing: Spacing) -> some View {
        self.lineSpacing(lineSpacing.rawValue)
    }
}

extension VStack {
    init(
        alignment: HorizontalAlignment = .center,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            content: content
        )
    }
}

extension HStack {
    init(
        alignment: VerticalAlignment = .center,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            content: content
        )
    }
}

extension Spacer {
    init(minLength: Spacing) {
        self.init(minLength: minLength.rawValue)
    }
}
