//
//  SharedState+Keys.swift
//  PublicSector
//
//  Created by Hamza Jadid on 29/09/2024.
//

import ComposableArchitecture

extension PersistenceReaderKey where Self == AppStorageKey<Settings.Appearance> {
  static var appearance: Self {
    appStorage("appearance")
  }
}

extension PersistenceReaderKey where Self == AppStorageKey<Settings.Language> {
  static var language: Self {
    appStorage("language")
  }
}
