//
//  MiqatPrayerTimesCalculationMethod.swift
//  MiqatKit
//
//  Created by Hamza Jadid on 27/03/2026.
//

import Miqat

/// The persisted, shareable prayer-times calculation method.
///
/// This is the "provider" that `MiqatService` reads on every `getMiqatData` call.
/// It is stored in the App Group container so the app and the widget agree on the
/// same calculation. The astronomical case carries its own coordinates so the widget
/// can fully recompute without reaching into app-only state.
public enum MiqatPrayerTimesCalculationMethod: Codable, Equatable, Sendable {
    case astronomical(AstronomicalConfig)
    case precomputed(Miqat.Provider)

    /// Default used when nothing has been selected yet.
    public static let `default` = MiqatPrayerTimesCalculationMethod.precomputed(.darElFatwa(.beirut))

    /// The astronomical configuration, or `nil` when the current method is precomputed.
    ///
    /// Convenience for screens that edit one slice of the config: read this, mutate a field, and
    /// write the whole method back via `MiqatService.setCalculationMethod`.
    public var asAstronomical: AstronomicalConfig? {
        switch self {
        case let .astronomical(config): config
        case .precomputed: nil
        }
    }
}

/// The full, self-describing configuration for an astronomical calculation.
///
/// It carries everything needed to recompute prayer times from scratch — coordinates, the method
/// (a preset or a user-defined pair of twilight angles), the Asr madhab, and per-prayer minute
/// offsets — so the widget can recompute without reaching into app-only state.
public struct AstronomicalConfig: Codable, Equatable, Sendable {
    public var coordinates: Miqat.Coordinates
    public var method: AstronomicalMethod
    public var mazhab: Miqat.Mazhab
    /// User-supplied per-prayer offsets, in minutes.
    public var adjustments: Miqat.TimeAdjustment

    public init(
        coordinates: Miqat.Coordinates,
        method: AstronomicalMethod,
        mazhab: Miqat.Mazhab = .shafi,
        adjustments: Miqat.TimeAdjustment = .zero
    ) {
        self.coordinates = coordinates
        self.method = method
        self.mazhab = mazhab
        self.adjustments = adjustments
    }
}

/// The astronomical method: one of the library presets, or a custom pair of twilight angles.
public enum AstronomicalMethod: Codable, Equatable, Sendable {
    case preset(Miqat.Method)
    case custom(fajrAngle: Double, ishaaAngle: Double)
}

extension Miqat.TimeAdjustment {
    /// No offset on any prayer.
    public static let zero = Miqat.TimeAdjustment(
        fajr: 0, sunrise: 0, dhuhr: 0, asr: 0, maghrib: 0, ishaa: 0
    )
}

// MARK: - Codable for the Miqat library types
//
// `Miqat.Method`, `Miqat.Provider`, `Miqat.ProviderCity`, and `Miqat.Coordinates` are
// `Equatable`/`Hashable` but not `Codable`. We encode enums by a stable string key so the
// persisted JSON does not depend on synthesized ordering and stays readable across versions.

extension Miqat.Method: @retroactive Codable {
    private var stringValue: String {
        switch self {
        case .muslimWorldLeague: "muslimWorldLeague"
        case .egyptian: "egyptian"
        case .ummAlQura: "ummAlQura"
        case .moonsightingCommittee: "moonsightingCommittee"
        case .northAmerica: "northAmerica"
        case .singapore: "singapore"
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "muslimWorldLeague": self = .muslimWorldLeague
        case "egyptian": self = .egyptian
        case "ummAlQura": self = .ummAlQura
        case "moonsightingCommittee": self = .moonsightingCommittee
        case "northAmerica": self = .northAmerica
        case "singapore": self = .singapore
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown Miqat.Method: \(value)"
            )
        }
    }
}

extension Miqat.ProviderCity: @retroactive Codable {
    private var stringValue: String {
        switch self {
        case .beirut: "beirut"
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "beirut": self = .beirut
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown Miqat.ProviderCity: \(value)"
            )
        }
    }
}

extension Miqat.Provider: @retroactive Codable {
    private enum CodingKeys: String, CodingKey {
        case darElFatwa
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .darElFatwa(city):
            try container.encode(city, forKey: .darElFatwa)
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let city = try container.decodeIfPresent(Miqat.ProviderCity.self, forKey: .darElFatwa) {
            self = .darElFatwa(city)
            return
        }
        throw DecodingError.dataCorruptedError(
            forKey: .darElFatwa,
            in: container,
            debugDescription: "Unknown Miqat.Provider"
        )
    }
}

extension Miqat.Coordinates: @retroactive Codable {
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            latitude: try container.decode(Double.self, forKey: .latitude),
            longitude: try container.decode(Double.self, forKey: .longitude)
        )
    }
}

extension Miqat.Mazhab: @retroactive Codable {
    private var stringValue: String {
        switch self {
        case .shafi: "shafi"
        case .hanafi: "hanafi"
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "shafi": self = .shafi
        case "hanafi": self = .hanafi
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown Miqat.Mazhab: \(value)"
            )
        }
    }
}

extension Miqat.TimeAdjustment: @retroactive Codable {
    private enum CodingKeys: String, CodingKey {
        case fajr, sunrise, dhuhr, asr, maghrib, ishaa
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fajr, forKey: .fajr)
        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(dhuhr, forKey: .dhuhr)
        try container.encode(asr, forKey: .asr)
        try container.encode(maghrib, forKey: .maghrib)
        try container.encode(ishaa, forKey: .ishaa)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            fajr: try container.decode(Int64.self, forKey: .fajr),
            sunrise: try container.decode(Int64.self, forKey: .sunrise),
            dhuhr: try container.decode(Int64.self, forKey: .dhuhr),
            asr: try container.decode(Int64.self, forKey: .asr),
            maghrib: try container.decode(Int64.self, forKey: .maghrib),
            ishaa: try container.decode(Int64.self, forKey: .ishaa)
        )
    }
}
