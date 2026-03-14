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
    public let hijriDate: MiqatHijriDate

    init(from islamicEventOccurrence: IslamicEventOccurrence) {
        self.event = islamicEventOccurrence.event
        self.hijriDate = MiqatHijriDate(from: islamicEventOccurrence.hijriDate)
        self.gregorianDate = Date(timeIntervalSince1970: TimeInterval(islamicEventOccurrence.gregorianTimestampSecs))
    }
}
