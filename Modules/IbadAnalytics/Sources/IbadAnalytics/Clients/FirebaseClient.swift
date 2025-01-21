//
//  FirebaseClient.swift
//  IbadAnalytics
//
//  Created by Hamza Jadid on 21/01/2025.
//

import Firebase
import FirebaseCrashlytics

public extension AnalyticsClient {
  static var firebaseClient: Self {
    return .init(
      sendAnalytics: { analyticsData in
        switch analyticsData {
        case let .event(name: name, properties: properties):
          Firebase.Analytics.logEvent(name, parameters: properties)

        case .userId(let id):
          Firebase.Analytics.setUserID(id)
          Crashlytics.crashlytics().setUserID(id)

        case let .userProperty(name: name, value: value):
          Firebase.Analytics.setUserProperty(value, forName: name)

        case .screen(name: let name):
          Firebase.Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name
          ])

        case .error(let error):
          Crashlytics.crashlytics().record(error: error)
        }
      }
    )
  }
}
