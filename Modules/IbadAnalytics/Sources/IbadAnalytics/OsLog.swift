//
//  OsLog.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 08/12/2024.
//

import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!

    static let analytics = Logger(subsystem: subsystem, category: "analytics")
}
