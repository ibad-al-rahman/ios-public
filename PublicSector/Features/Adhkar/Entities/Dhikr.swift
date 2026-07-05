//
//  Dhikr.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import Foundation

/// A single dhikr in a tour: its Arabic text (verbatim, not localized) and the
/// number of times it should be repeated.
struct Dhikr: Equatable, Identifiable, Sendable {
    let id: UUID
    let arabicText: String
    let target: Int
    var isVerse: Bool
}

/// Static adhkar collections. Hardcoded for now — trivially movable to a bundled
/// JSON resource or remote source later without touching the features that consume it.
enum Adhkar {
    static let morning: [Dhikr] = [
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            arabicText: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ. اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ",
            target: 1,
            isVerse: true
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            arabicText: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            target: 3
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            arabicText: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            target: 100
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
            arabicText: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            target: 10
        ),
    ]

    static let evening: [Dhikr] = [
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!,
            arabicText: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ. اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ",
            target: 1,
            isVerse: true
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000002")!,
            arabicText: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            target: 3
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000003")!,
            arabicText: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            target: 100
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000004")!,
            arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ",
            target: 1
        ),
    ]
}
