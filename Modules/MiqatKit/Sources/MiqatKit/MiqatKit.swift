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

    /// Computes prayer times for an explicit method without reading or writing shared storage.
    /// Used for previewing an in-flight configuration in settings.
    public var previewMiqatData: @Sendable (
        _ timestampSecs: TimeInterval,
        _ method: MiqatPrayerTimesCalculationMethod
    ) -> MiqatData = { MiqatData(timestampSecs: $0, method: $1) }

    public var getIslamicEvents: @Sendable (_ year: Int) -> [MiqatEventOccurrence] = { _ in [] }

    /// Persists the calculation method to the shared App Group container. Subsequent
    /// `getMiqatData` calls (in both the app and the widget) use the new method.
    ///
    /// When the method is astronomical, its config is also retained separately so it can be restored
    /// after the user toggles to precomputed and back (see `getRetainedAstronomicalConfig`).
    public var setCalculationMethod: @Sendable (_ method: MiqatPrayerTimesCalculationMethod) -> Void

    /// The currently persisted calculation method.
    public var getCalculationMethod: @Sendable () -> MiqatPrayerTimesCalculationMethod = { .default }

    /// The last astronomical configuration the user set, retained across toggles to precomputed.
    /// `nil` if the user has never configured an astronomical method.
    public var getRetainedAstronomicalConfig: @Sendable () -> AstronomicalConfig? = { nil }
}

extension MiqatService: DependencyKey {
    public static var liveValue: MiqatService {
        return MiqatService(
            getMiqatData: { timestampSecs in
                @Shared(.calculationMethod) var method
                return MiqatData(timestampSecs: timestampSecs, method: method)
            },
            previewMiqatData: { timestampSecs, method in
                MiqatData(timestampSecs: timestampSecs, method: method)
            },
            getIslamicEvents: { year in
                Miqat.eventsForGregorianYear(gregorianYear: Int32(year)).map(MiqatEventOccurrence.init)
            },
            setCalculationMethod: { method in
                @Shared(.calculationMethod) var stored
                $stored.withLock { $0 = method }
                // Retain the astronomical config so it survives a switch to precomputed.
                if let config = method.asAstronomical {
                    @Shared(.retainedAstronomicalConfig) var retained
                    $retained.withLock { $0 = config }
                }
            },
            getCalculationMethod: {
                @Shared(.calculationMethod) var method
                return method
            },
            getRetainedAstronomicalConfig: {
                @Shared(.retainedAstronomicalConfig) var config
                return config
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
