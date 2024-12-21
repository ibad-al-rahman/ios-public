//
//  PrayerTimesSha1.swift
//  PublicSector
//
//  Created by Hamza Jadid on 21/12/2024.
//

typealias PrayerTimesSha1 = [String: String]

extension PrayerTimesSha1 {
    func getSha1(year: Int) -> String? {
        let yearString = String(format: "%d", year)
        guard let value = self[yearString] else { return nil }
        return value
    }

    mutating func setSha1(sha1: String, for year: Int) {
        let yearString = String(format: "%d", year)
        self[yearString] = sha1
    }
}
