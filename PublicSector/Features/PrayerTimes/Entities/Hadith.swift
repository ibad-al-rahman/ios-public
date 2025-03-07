//
//  Hadith.swift
//  PublicSector
//
//  Created by Hamza Jadid on 07/03/2025.
//

import IbadRepositories

struct Hadith: Equatable {
    let hadith: String
    let note: String?
}

extension Hadith {
    init?(from storage: YearWeekPrayerTimesStorage.HadithStorage?) {
        guard let storage else { return nil }
        self.hadith = storage.hadith
        self.note = storage.note
    }
}
