//
//  MiqatHijriDate+Formatted.swift
//  PublicSector
//
//  Created by Hamza Jadid on 14/03/2026.
//

import Foundation
import MiqatKit

extension MiqatHijriDate {
    var formatted: String? {
        if let localeMonthName = self.localeMonth {
            "\(self.day) \(localeMonthName) \(String(self.year))"
        } else {
            nil
        }
    }
}
