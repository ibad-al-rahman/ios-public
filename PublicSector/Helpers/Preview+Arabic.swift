//
//  Preview+Arabic.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import SwiftUI

struct ArabicPreview: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(\.locale, Locale(identifier: "ar"))
            .environment(\.layoutDirection, .rightToLeft)
    }
}

extension View {
    func arabicEnvironment() -> some View {
        modifier(ArabicPreview())
    }
}
