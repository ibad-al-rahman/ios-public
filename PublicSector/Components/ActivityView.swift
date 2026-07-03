//
//  ActivityView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import SwiftUI
import UIKit

/// A thin wrapper around `UIActivityViewController` so the system share sheet can
/// be presented from SwiftUI state (e.g. `.sheet(item:)`) rather than eagerly via
/// `ShareLink`, which would force the shared item to be built up front.
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}
