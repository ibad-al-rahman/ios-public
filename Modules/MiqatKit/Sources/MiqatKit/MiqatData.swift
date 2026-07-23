//
//  MiqatData.swift
//  MiqatKit
//
//  Created by Hamza Jadid on 11/03/2026.
//

import Miqat
import Foundation

public struct MiqatData: Sendable, Equatable, Identifiable {
    public let id: String
    public let gregorian: Date

    public let imsak: Date?
    public let fajr: Date
    public let sunrise: Date
    public let eid: Date?
    public let dhuhr: Date
    public let asr: Date
    public let maghrib: Date
    public let ishaa: Date

    public let hijriDate: MiqatHijriDate

    public let islamicEvents: [IslamicEvent]

    init(timestampSecs: TimeInterval, method: MiqatPrayerTimesCalculationMethod) {
        let date = Date(timeIntervalSince1970: timestampSecs)
        self.gregorian = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        self.id = formatter.string(from: date)

        let prayerTimes: Miqat.PrayerTimes = switch method {
        case let .precomputed(provider):
            .fromPrecomputed(dateUtcTimestampSecs: Int64(timestampSecs), provider: provider)
        case let .astronomical(config):
            Self.astronomicalPrayerTimes(timestampSecs: timestampSecs, config: config)
        }

        self.fajr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.fajr()))
        self.sunrise = Date(timeIntervalSince1970: TimeInterval(prayerTimes.sunrise()))
        self.dhuhr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.dhuhr()))
        self.asr = Date(timeIntervalSince1970: TimeInterval(prayerTimes.asr()))
        self.maghrib = Date(timeIntervalSince1970: TimeInterval(prayerTimes.maghrib()))
        self.ishaa = Date(timeIntervalSince1970: TimeInterval(prayerTimes.ishaa()))

        let hijriDateInfo = HijriDateInfo.fromTimestamp(timestampSecs: Int64(timestampSecs))
        let hijriDate = hijriDateInfo.date()
        self.hijriDate = MiqatHijriDate(from: hijriDate)

        self.islamicEvents = hijriDateInfo.events()

        // if ramadan then fill imsak (fajr - 20mins)
        self.imsak = if hijriDate.month == 9 {
            Calendar.current.date(byAdding: .minute, value: -20, to: self.fajr)
        } else {
            nil
        }

        // if eid then fill eid prayer time (sunrise + 45mins)
        self.eid = if self.islamicEvents.contains(where: { $0 == .eidAlAdha || $0 == .eidAlFitr }) {
            Calendar.current.date(byAdding: .minute, value: 45, to: self.sunrise)
        } else {
            nil
        }
    }

    /// Computes astronomical prayer times for a config.
    ///
    /// A preset method with no user customization goes through `fromMethod` so its exact library
    /// behavior is preserved — notably Umm al-Qura's interval-based Ishaa, which the flat
    /// `CalculationParameters` view collapses to a `0°` angle. Any custom method, non-Shafi
    /// madhab, or non-zero offset requires the parameter-based path.
    private static func astronomicalPrayerTimes(
        timestampSecs: TimeInterval,
        config: AstronomicalConfig
    ) -> Miqat.PrayerTimes {
        let timestamp = Int64(timestampSecs)

        if case let .preset(method) = config.method,
           config.mazhab == .shafi,
           config.adjustments == .zero {
            return .fromMethod(
                dateUtcTimestampSecs: timestamp,
                coordinates: config.coordinates,
                method: method
            )
        }

        let base: Miqat.CalculationParameters = switch config.method {
        case let .preset(method):
            Miqat.parametersForMethod(method: method)
        case let .custom(fajrAngle, ishaaAngle):
            Miqat.CalculationParameters(
                fajrAngle: fajrAngle,
                ishaaAngle: ishaaAngle,
                mazhab: .shafi,
                highLatitudeRule: .middleOfTheNight,
                adjustments: .zero,
                methodAdjustments: .zero,
                rounding: .nearest
            )
        }

        let parameters = Miqat.CalculationParameters(
            fajrAngle: base.fajrAngle,
            ishaaAngle: base.ishaaAngle,
            mazhab: config.mazhab,
            highLatitudeRule: base.highLatitudeRule,
            adjustments: config.adjustments,
            methodAdjustments: base.methodAdjustments,
            rounding: base.rounding
        )

        return .fromParameters(
            dateUtcTimestampSecs: timestamp,
            coordinates: config.coordinates,
            parameters: parameters
        )
    }
}
