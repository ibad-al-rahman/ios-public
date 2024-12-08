//
//  PrayerTimesDao.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Foundation
import OSLog
import SwiftData

struct PrayerTimesDao {
    let container: ModelContainer

    init() {
        container = try! ModelContainer(for: DayPrayerTimesModel.self)
    }

    func create(_ days: [DayPrayerTimesModel]) throws {
        let context = ModelContext(container)
        for day in days {
            context.insert(day)
        }
        Logger.local.info("Saving prayer times")
        try context.save()
    }

    func readPrayerTime(year: Int, month: Int, day: Int) -> DayPrayerTimesModel? {
        let context = ModelContext(container)
        let idStr = String(format: "%04d%02d%02d", year, month, day)
        Logger.local.info("Querying \(idStr) prayer time")
        guard let id = Int(idStr) else { return nil }
        let fetchDescriptor = FetchDescriptor<DayPrayerTimesModel>(
            predicate: #Predicate { model in model.id == id }
        )
        guard let days = try? context.fetch(fetchDescriptor) else { return nil }
        return days.first
    }

    func read(
        predicate: Predicate<DayPrayerTimesModel>?,
        sortDescriptors: SortDescriptor<DayPrayerTimesModel>...
    ) throws -> [DayPrayerTimesModel] {
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<DayPrayerTimesModel>(
            predicate: predicate,
            sortBy: sortDescriptors
        )
        return try context.fetch(fetchDescriptor)
    }
}

@Model
public final class DayPrayerTimesModel {
    @Attribute(.unique) public var id: Int
    public var gregorian: String
    public var hijri: String
    public var prayerTimes: PrayerTimesModel

    init(
        id: Int,
        gregorian: String,
        hijri: String,
        prayerTimes: PrayerTimesModel
    ) {
        self.id = id
        self.gregorian = gregorian
        self.hijri = hijri
        self.prayerTimes = prayerTimes
    }
}

public struct PrayerTimesModel: Codable {
    public var fajer: String
    public var sunrise: String
    public var dhuhr: String
    public var asr: String
    public var maghrib: String
    public var ishaa: String
}

extension DayPrayerTimesModel {
    public convenience init(from response: DayPrayerTimesResponse) {
        self.init(
            id: response.id,
            gregorian: response.gregorian,
            hijri: response.hijri,
            prayerTimes: PrayerTimesModel(
                fajer: response.prayerTimes.fajer,
                sunrise: response.prayerTimes.sunrise,
                dhuhr: response.prayerTimes.dhuhr,
                asr: response.prayerTimes.asr,
                maghrib: response.prayerTimes.maghrib,
                ishaa: response.prayerTimes.ishaa
            )
        )
    }
}
