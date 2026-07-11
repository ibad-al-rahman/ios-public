//
//  RootRoute+Notification.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

/// Resolves a tapped local notification to the route it should open. A tapped
/// notification carries only its identifier (no URL), so this is the notification-tap
/// counterpart to the URL router.
extension RootRoute {
    /// Prefix of every prayer-time notification identifier
    /// (`prayertimes-<prayer>-<yyyyMMdd>`), set by `PrayerTimesNotificationService`.
    private static let prayerTimesIdentifierPrefix = "prayertimes-"

    init?(notificationIdentifier: String) {
        if let collection = AdhkarCollection(notificationIdentifier: notificationIdentifier) {
            self = .adhkar(.collection(collection))
        } else if notificationIdentifier.hasPrefix(Self.prayerTimesIdentifierPrefix) {
            self = .prayerTimes
        } else {
            return nil
        }
    }
}
