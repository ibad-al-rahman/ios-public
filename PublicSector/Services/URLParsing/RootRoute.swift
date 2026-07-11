//
//  RootRoute.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import CasePaths
import URLRouting

/// Top of the deep-link route tree. New surfaces slot in as sibling cases with their
/// own sub-router.
@CasePathable
enum RootRoute: Equatable {
    case adhkar(AdhkarRoute)
    /// Opens the prayer times tab. Parameterless — the screen already shows the full
    /// day, so which prayer/day fired the notification doesn't change navigation.
    case prayerTimes

    static var router: some ParserPrinter<URLRequestData, RootRoute> {
        OneOf {
            Route(.case(RootRoute.adhkar)) {
                AdhkarRoute.router
            }

            Route(.case(RootRoute.prayerTimes)) {
                Host("prayer-times")
            }
        }
    }
}
