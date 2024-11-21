//
//  WebLinks.swift
//  PublicSector
//
//  Created by Hamza Jadid on 21/11/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import UIKit

@DependencyClient
struct WebLinks: Sendable {
    var openDonationLink: @Sendable () async -> Void
    var openContactUs: @Sendable () async -> Void
}

extension WebLinks: DependencyKey {
    static let liveValue: WebLinks = {
        @Dependency(\.openURL) var openUrl

        return WebLinks(
            openDonationLink: {
                if let url = URL(string: "https://www.ibad.org.lb/index.php/home/donationform") {
                    await openUrl(url)
                }
            },
            openContactUs: {
                if let url = URL(string: "https://www.ibad.org.lb/index.php/home/contactus") {
                    await openUrl(url)
                }
            }
        )
    }()
}

extension WebLinks {
    static let testValue: WebLinks = {
        WebLinks()
    }()
}

extension DependencyValues {
    var webLinks: WebLinks {
        get { self[WebLinks.self] }
        set { self[WebLinks.self] = newValue }
    }
}
