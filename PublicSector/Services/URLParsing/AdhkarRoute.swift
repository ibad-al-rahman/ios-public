//
//  AdhkarRoute.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import CasePaths
import URLRouting

/// Routes into the adhkar surface. Collection-level for now: a link resolves to a
/// named collection and opens its tour.
///
/// Custom-scheme links look like `app://adhkar/morning`. Under a custom scheme the
/// first component (`adhkar`) lands in the URL's *host* rather than its path, so the
/// parser matches the host and then the collection slug (`AdhkarCollection`'s raw
/// value) as the sole path segment.
@CasePathable
enum AdhkarRoute: Equatable {
    case collection(AdhkarCollection)

    static var router: some ParserPrinter<URLRequestData, AdhkarRoute> {
        OneOf {
            Route(.case(AdhkarRoute.collection)) {
                Host("adhkar")
                Path { Parse(.string.representing(AdhkarCollection.self)) }
            }
        }
    }
}
