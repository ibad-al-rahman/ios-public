//
//  OsLog.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 08/12/2024.
//

import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!

    static let local = Logger(subsystem: subsystem, category: "local")
    static let remote = Logger(subsystem: subsystem, category: "remote")
}
