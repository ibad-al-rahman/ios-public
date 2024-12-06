//
//  PrayerTimesDao.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Foundation
import SwiftData

struct PrayerTimesDao {
    let container: ModelContainer

    init() throws {
        container = try ModelContainer(for: PrayerTimesModel.self)
    }

    func read(
        predicate: Predicate<PrayerTimesModel>?,
        sortDescriptors: SortDescriptor<PrayerTimesModel>...
    ) throws -> [PrayerTimesModel] {
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<PrayerTimesModel>(
            predicate: predicate,
            sortBy: sortDescriptors
        )
        return try context.fetch(fetchDescriptor)
    }
}

@Model
public final class PrayerTimesModel {
    @Attribute(.unique) var date: String
    var hijri: String

    init(date: String, hijri: String) {
        self.date = date
        self.hijri = hijri
    }
}
