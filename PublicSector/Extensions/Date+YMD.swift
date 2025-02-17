//
//  Date+YMD.swift
//  PublicSector
//
//  Created by Hamza Jadid on 25/01/2025.
//

import Foundation

struct Ymd {
    let year: Int
    let month: Int
    let day: Int
}

extension Date {
    var stringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let date = dateFormatter.string(from: self)
        return date
    }

    var ymd: Ymd? {
        let components = Calendar.current.dateComponents(
            [.year, .month, .day], from: self
        )
        guard let year = components.year,
              let month = components.month,
              let day = components.day
        else { return nil }
        return Ymd(year: year, month: month, day: day)
    }
}
