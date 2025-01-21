//
//  AnalyticsDependency.swift
//  IbadAnalytics
//
//  Created by Hamza Jadid on 21/01/2025.
//

import ComposableArchitecture

extension AnalyticsClient: DependencyKey {
    public static let liveValue: AnalyticsClient = .merge(
        .osLogger,
        .firebaseClient
    )
    public static let testValue: AnalyticsClient = .unimplemented
    public static let previewValue: AnalyticsClient = .osLogger
}

public extension DependencyValues {
    var analyticsClient: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}
