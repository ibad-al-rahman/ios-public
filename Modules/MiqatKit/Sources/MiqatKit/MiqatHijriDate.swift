//
//  MiqatHijriDate.swift
//  MiqatKit
//
//  Created by Hamza Jadid on 14/03/2026.
//

import Foundation
import Miqat

public struct MiqatHijriDate: Sendable, Equatable {
    public let day: Int
    public let month: Int
    public let year: Int

    public var localeMonth: String? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.dateFormat = "M"

        guard let date = formatter.date(from: "\(self.month)")
        else { return nil }

        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }

    init(from hijriDate: HijriDate) {
        self.day = Int(hijriDate.day)
        self.month = Int(hijriDate.month)
        self.year = Int(hijriDate.year)
    }
}
