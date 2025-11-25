//
//  PublicSectorApp.swift
//  PublicSector
//
//  Created by Hamza Jadid on 01/09/2024.
//

import SwiftUI

@main
struct PublicSectorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        loadRocketSimConnect()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private func loadRocketSimConnect() {
    #if DEBUG
    guard (Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
        print("Failed to load linker framework")
        return
    }
    print("RocketSim Connect successfully linked")
    #endif
}

