//
//  Dhikr.swift
//  PublicSector
//
//  Created by Hamza Jadid on 06/03/2026.
//

struct Dhikr: Equatable, Identifiable {
    let id: Int
    let ar: String
    let count: Int
    let source: String?
    let narrator: String?
    let virtue: String?

    var hasInfo: Bool {
        source != nil || narrator != nil || virtue != nil
    }

    init(id: Int, ar: String, count: Int, source: String? = nil, narrator: String? = nil, virtue: String? = nil) {
        self.id = id
        self.ar = ar
        self.count = count
        self.source = source
        self.narrator = narrator
        self.virtue = virtue
    }
}
