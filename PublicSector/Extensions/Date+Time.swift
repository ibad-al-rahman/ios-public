//
//  Date+Time.swift
//  PublicSector
//
//  Created by Hamza Jadid on 16/02/2025.
//

import Foundation

extension Date {
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let time = timeFormatter.string(from: self)
        return time
    }
}
