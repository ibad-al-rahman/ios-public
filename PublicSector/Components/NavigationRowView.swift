//
//  NavigationRowView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/11/2024.
//

import SwiftUI

struct NavigationRowView: View {
    let label: LocalizedStringKey
    let systemName: String

    var body: some View {
        HStack {
            Label(label, systemImage: systemName)
                .foregroundStyle(.primary, .primary)
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .contentShape(Rectangle())
    }

    init(_ label: LocalizedStringKey, systemName: String) {
        self.label = label
        self.systemName = systemName
    }
}
