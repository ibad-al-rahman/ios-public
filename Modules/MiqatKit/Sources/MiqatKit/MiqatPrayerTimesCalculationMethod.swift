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
    case astronomical(Miqat.Method, Miqat.Coordinates)
    case precomputed(Miqat.Provider)

    /// Default used when nothing has been selected yet.
    public static let `default` = MiqatPrayerTimesCalculationMethod.precomputed(.darElFatwa(.beirut))
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
