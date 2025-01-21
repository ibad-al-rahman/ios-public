//
//  AnalyticsClient.swift
//  IbadAnalytics
//
//  Created by Hamza Jadid on 21/01/2025.
//

import Foundation
import XCTestDynamicOverlay

public struct AnalyticsClient: Sendable {
    public var sendAnalytics: @Sendable (AnalyticsData) -> Void

    public init(sendAnalytics: @escaping @Sendable (AnalyticsData) -> Void) {
        self.sendAnalytics = sendAnalytics
    }
}

extension AnalyticsClient {
    public static func merge(_ clients: AnalyticsClient...) -> Self {
        .init { data in
            clients.forEach { $0.sendAnalytics(data) }
        }
    }
}

extension AnalyticsClient {
    static let unimplemented: Self = Self(
        sendAnalytics: IssueReporting.unimplemented("\(Self.self).sendAnalytics")
    )

    public static let consoleLogger: Self = .init(
        sendAnalytics: { analytics in
#if DEBUG
            print("[Analytics] ✅ \(analytics)")
#endif
        }
    )
}

#if DEBUG
extension AnalyticsClient {
    public mutating func expect(_ expectedAnalytics: AnalyticsData?) {
        let fulfill = expectation(description: "analytics")
        self.sendAnalytics = { @Sendable [self] analytics in
            if analytics == expectedAnalytics {
                fulfill()
            } else {
                self.sendAnalytics(analytics)
            }
        }
    }
}
#endif
