//
//  DayEvent.swift
//  PublicSector
//
//  Created by Hamza Jadid on 31/12/2024.
//

import IbadRepositories

struct DayEvent: Equatable {
    let ar: String
    let en: String?
}

extension DayEvent {
    init?(from response: DayPrayerTimesResponse) {
        guard let event = response.event else { return nil }
        self.en = event.en
        self.ar = event.ar
    }

    init?(from storage: DayPrayerTimesStorage) {
        guard let event = storage.event else { return nil }
        self.en = event.en
        self.ar = event.ar
    }
}
