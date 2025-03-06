//
//  AnalyticsData.swift
//  IbadAnalytics
//
//  Created by Hamza Jadid on 21/01/2025.
//

public enum AnalyticsData: Equatable, Sendable {
    case event(name: String, properties: [String: String] = [:])
    case screen(name: String)
    case userId(String)
    case userProperty(name: String, value: String)
    case error(Error)

    public static func == (lhs: AnalyticsData, rhs: AnalyticsData) -> Bool {
        switch (lhs, rhs) {
        case let (.event(lhsName, lhsProps), .event(rhsName, rhsProps)):
            return lhsName == rhsName && lhsProps == rhsProps
        case let (.screen(lhsName), .screen(rhsName)):
            return lhsName == rhsName
        case let (.userId(lhsId), .userId(rhsId)):
            return lhsId == rhsId
        case let (.userProperty(name: lhsName, value: lhsValue), .userProperty(name: rhsName, value: rhsValue)):
            return lhsName == rhsName && lhsValue == rhsValue
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }

    public var debugDescription: String {
        switch self {
        case .error(let err):
            return err.localizedDescription

        case .screen(let name):
            return "{ eventType: screen, name: \(name) }"

        case .userId(let id):
            return "{ eventType: userId, id: \(id) }"

        case let .userProperty(name, value):
            return "{ eventType: userProperty, \(name): \(value) }"

        case let .event(name, properties):
            let stringifiedProperties = properties
                .map { "\($0.key): \($0.value)" }
                .joined(separator: ",")
            return "{ eventType: event, name: \(name), properties: { \(stringifiedProperties) } }"
        }
    }
}

extension AnalyticsData: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .event(name: value, properties: [:])
    }
}
