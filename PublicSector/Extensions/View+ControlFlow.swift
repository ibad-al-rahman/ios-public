//
//  View+ControlFlow.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifLet<T, Content: View>(_ optional: T?, content: (T, Self) -> Content) -> some View {
        if let value = optional {
            content(value, self)
        } else {
            self
        }
    }
}
