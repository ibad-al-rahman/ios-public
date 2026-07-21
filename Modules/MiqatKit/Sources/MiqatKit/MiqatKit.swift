// The Swift Programming Language
// https://docs.swift.org/swift-book

import Miqat
import Dependencies
import DependenciesMacros
import Foundation
import Sharing

@DependencyClient
public struct MiqatService: Sendable {
    public var getMiqatData: @Sendable (
        _ timestampSecs: TimeInterval
    ) -> MiqatData = { MiqatData(timestampSecs: $0, method: .default) }

    public var getIslamicEvents: @Sendable (_ year: Int) -> [MiqatEventOccurrence] = { _ in [] }

    /// Persists the calculation method to the shared App Group container. Subsequent
    /// `getMiqatData` calls (in both the app and the widget) use the new method.
    public var setCalculationMethod: @Sendable (_ method: MiqatPrayerTimesCalculationMethod) -> Void

    /// The currently persisted calculation method.
    public var getCalculationMethod: @Sendable () -> MiqatPrayerTimesCalculationMethod = { .default }
}

extension MiqatService: DependencyKey {
    public static var liveValue: MiqatService {
        return MiqatService(
            getMiqatData: { timestampSecs in
                @Shared(.calculationMethod) var method
                return MiqatData(timestampSecs: timestampSecs, method: method)
            },
            getIslamicEvents: { year in
                Miqat.eventsForGregorianYear(gregorianYear: Int32(year)).map(MiqatEventOccurrence.init)
            },
            setCalculationMethod: { method in
                @Shared(.calculationMethod) var stored
                $stored.withLock { $0 = method }
            },
            getCalculationMethod: {
                @Shared(.calculationMethod) var method
                return method
            }
        )
    }
}

extension MiqatService: TestDependencyKey {
    public static var previewValue: MiqatService {
        MiqatService()
    }

    public static var testValue: MiqatService {
        MiqatService()
    }
}

public extension DependencyValues {
    var miqatService: MiqatService {
        get { self[MiqatService.self] }
        set { self[MiqatService.self] = newValue }
    }
}
