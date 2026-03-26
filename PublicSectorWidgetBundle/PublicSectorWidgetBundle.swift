//
//  PublicSectorWidgetBundle.swift
//  PrayerTimesWidget
//
//  Created by Hamza Jadid on 02/01/2025.
//

import WidgetKit
import SwiftUI

@main
struct PublicSectorWidgetBundle: WidgetBundle {
    var body: some Widget {
        PrayerTimesWidget()
        HijriDateWidget()
    }
}
