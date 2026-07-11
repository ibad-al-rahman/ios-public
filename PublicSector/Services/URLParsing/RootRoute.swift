//
//  RootRoute.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import CasePaths
import URLRouting

/// Top of the deep-link route tree. Adhkar is the only surface today; new surfaces
/// slot in as sibling cases with their own sub-router.
@CasePathable
enum RootRoute: Equatable {
    case adhkar(AdhkarRoute)

    static var router: some ParserPrinter<URLRequestData, RootRoute> {
        OneOf {
            Route(.case(RootRoute.adhkar)) {
                AdhkarRoute.router
            }
        }
    }
}
