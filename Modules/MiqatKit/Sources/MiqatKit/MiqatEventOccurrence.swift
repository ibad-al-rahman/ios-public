//
//  MiqatEventOccurance.swift
//  MiqatKit
//
//  Created by Hamza Jadid on 14/03/2026.
//

import Foundation
import Miqat

public struct MiqatEventOccurrence: Sendable, Equatable {
    public let event: IslamicEvent
    public let gregorianDate: Date

    public let hijriDay: Int
    public let hijriMonth: Int
    public let hijriYear: Int

    public var hijriLocaleMonth: String? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.dateFormat = "M"

        guard let date = formatter.date(from: "\(self.hijriMonth)")
        else { return nil }

        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }

    init(from islamicEventOccurrence: IslamicEventOccurrence) {
        self.event = islamicEventOccurrence.event

        self.hijriDay = Int(islamicEventOccurrence.hijriDate.day)
        self.hijriMonth = Int(islamicEventOccurrence.hijriDate.month)
        self.hijriYear = Int(islamicEventOccurrence.hijriDate.year)

        self.gregorianDate = Date(timeIntervalSince1970: TimeInterval(islamicEventOccurrence.gregorianTimestampSecs))
    }
}
