//
//  OSLogClient.swift
//  IbadAnalytics
//
//  Created by Hamza Jadid on 21/01/2025.
//

import OSLog

public extension AnalyticsClient {
    static var osLogger: Self {
        return .init(
            sendAnalytics: { analytics in
                switch analytics {
                case .error:
                    Logger.analytics.error("Analytics: \(analytics.debugDescription)")

                default:
                    Logger.analytics.info("Analytics: \(analytics.debugDescription)")
                }
            }
        )
    }
}
