// The Swift Programming Language
// https://docs.swift.org/swift-book

import Azan
import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct AzanService: Sendable {
    public var getPrecomputedPrayerTimes: (
        _ timestampSecs: TimeInterval, _ provider: Provider
    ) -> PrayerTimes = { _, _ in
        let azanPrayerTimes = Azan.PrayerTimes.fromPrecomputed(
            dateUtcTimestampSecs: Int64(Date.now.timeIntervalSince1970),
            provider: .darElFatwa(.beirut)
        )
        return PrayerTimes(from: azanPrayerTimes)
    }
}

extension AzanService: DependencyKey {
    public static var liveValue: AzanService {
        return AzanService(
            getPrecomputedPrayerTimes: { timestampSecs, provider in
                let azanPrayerTimes = Azan.PrayerTimes.fromPrecomputed(
                    dateUtcTimestampSecs: Int64(timestampSecs),
                    provider: provider
                )
                return PrayerTimes(from: azanPrayerTimes)
            }
        )
    }
}

extension AzanService: TestDependencyKey {
    public static var previewValue: AzanService {
        AzanService()
    }

    public static var testValue: AzanService {
        AzanService()
    }
}

public extension DependencyValues {
    var azanService: AzanService {
        get { self[AzanService.self] }
        set { self[AzanService.self] = newValue }
    }
}
