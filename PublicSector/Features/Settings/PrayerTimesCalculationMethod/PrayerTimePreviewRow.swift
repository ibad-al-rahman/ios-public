//
//  PrayerTimePreviewRow.swift
//  PublicSector
//
//  Created by Hamza Jadid on 23/07/2026.
//

import MiqatKit
import SwiftUI

/// A single prayer name paired with its computed time, used to preview a calculation method.
struct PrayerTimePreviewRow: View {
    let prayer: Prayer
    let time: Date

    var body: some View {
        LabeledContent {
            Text(time, format: .dateTime.hour().minute())
        } label: {
            Text(prayer.localizedStringKey)
        }
    }
}
