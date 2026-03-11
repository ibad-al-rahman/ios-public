//
//  DayInfo.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/03/2026.
//

import Foundation

struct DayInfo: Equatable {
    var imsak: Date?
    var fajr: Date
    var sunrise: Date
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var ishaa: Date

    var hijri: String
}
