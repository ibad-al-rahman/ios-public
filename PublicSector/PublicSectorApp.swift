//
//  PublicSectorApp.swift
//  PublicSector
//
//  Created by Hamza Jadid on 01/09/2024.
//

import IbadDesign
import SwiftUI

@main
struct PublicSectorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        IbadDesign.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
