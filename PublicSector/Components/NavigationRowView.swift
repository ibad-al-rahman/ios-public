//
//  NavigationRowView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/11/2024.
//

import SwiftUI

struct NavigationRowView: View {
    let label: LocalizedStringKey
    let badge: String?
    let systemName: String

    var body: some View {
        HStack {
            Label(label, systemImage: systemName)
                .foregroundStyle(.primary, .primary)
            Spacer()

            if let badge {
                Text(badge)
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "chevron.forward")
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
    }

    init(_ label: LocalizedStringKey, badge: String? = nil, systemName: String) {
        self.label = label
        self.badge = badge
        self.systemName = systemName
    }
}

struct DeveloperNavigationRowView: View {
    let verbatim: String
    let systemName: String

    var body: some View {
        HStack {
            Label(
                title: { Text(verbatim: verbatim) },
                icon: { Image(systemName: systemName) }
            )
            .foregroundStyle(.primary, .primary)
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .contentShape(Rectangle())
    }

    init(verbatim: String, systemName: String) {
        self.verbatim = verbatim
        self.systemName = systemName
    }
}
