//
//  Dhikr.swift
//  PublicSector
//
//  Created by Hamza Jadid on 04/07/2026.
//

import Foundation

/// A single ayah of a Quranic passage: its text and, when it carries one, its
/// number within the surah. `number` is `nil` for the Basmalah, which precedes
/// a surah's numbered ayat and is not itself numbered here.
struct Ayah: Equatable, Sendable {
    let number: Int?
    let text: String

    init(_ number: Int?, _ text: String) {
        self.number = number
        self.text = text
    }
}

/// A single dhikr in a tour: its Arabic text (verbatim, not localized) and the
/// number of times it should be repeated.
///
/// For Quranic passages, `ayat` holds the individual verses (each with its
/// number) so the UI can render Mushaf-style verse markers. For plain adhkar it
/// is empty and `arabicText` is the sole source of text.
struct Dhikr: Equatable, Identifiable, Sendable {
    let id: UUID
    let arabicText: String
    let target: Int
    var isVerse: Bool = false
    var ayat: [Ayah] = []

    /// Builds a verse dhikr from its individual ayat. `arabicText` is derived by
    /// joining the ayah texts, so non-verse consumers (and accessibility) still
    /// see the full passage.
    init(id: UUID, ayat: [Ayah], target: Int) {
        self.id = id
        self.ayat = ayat
        self.target = target
        self.isVerse = true
        self.arabicText = ayat.map(\.text).joined(separator: " ")
    }

    /// Builds a plain (non-verse) dhikr from a single block of text.
    init(id: UUID, arabicText: String, target: Int) {
        self.id = id
        self.arabicText = arabicText
        self.target = target
        self.isVerse = false
        self.ayat = []
    }
}

/// A named, addressable set of adhkar. The raw value is the stable slug used for
/// identification (and, later, deep links like `app://adhkar/morning`). Contents are
/// hardcoded for now — trivially movable to a bundled JSON resource or remote source
/// later without touching the features that consume it.
enum AdhkarCollection: String, CaseIterable, Identifiable, Sendable {
    case morning
    case evening

    var id: String { rawValue }

    /// Localized-string key for the collection's display name.
    var titleKey: String {
        switch self {
        case .morning: "morning_adhkar"
        case .evening: "evening_adhkar"
        }
    }

    /// SF Symbol shown in the list row.
    var systemImage: String {
        switch self {
        case .morning: "sun.horizon"
        case .evening: "moon.stars"
        }
    }

    /// Identifier of the scheduled local notification for this collection. The
    /// single source of truth for the `adhkar-` prefixed identifiers, shared by the
    /// notification scheduler and the deep-link resolver that maps a tapped
    /// notification back to its collection.
    var notificationIdentifier: String { "adhkar-\(rawValue)" }

    /// The collection a tapped notification refers to, or `nil` if the identifier is
    /// not one of ours.
    init?(notificationIdentifier: String) {
        let match = AdhkarCollection.allCases.first { $0.notificationIdentifier == notificationIdentifier }
        guard let match else { return nil }
        self = match
    }

    var adhkar: [Dhikr] {
        switch self {
        case .morning: Self.morningAdhkar
        case .evening: Self.eveningAdhkar
        }
    }

    private static let morningAdhkar: [Dhikr] = [
        // Āyat al-Kursī (al-Baqarah 2:255) — recited once in the morning.
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            ayat: [
                Ayah(nil, "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ"),
                Ayah(255, "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ، لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ، لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ، مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ، يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ، وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ، وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ، وَلَا يَؤُودُهُ حِفْظُهُمَا، وَهُوَ الْعَلِيُّ الْعَظِيمُ"),
            ],
            target: 1
        ),
        // Sūrat al-Ikhlāṣ — recited three times.
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            ayat: [
                Ayah(nil, "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ"),
                Ayah(1, "قُلْ هُوَ اللَّهُ أَحَدٌ"),
                Ayah(2, "اللَّهُ الصَّمَدُ"),
                Ayah(3, "لَمْ يَلِدْ وَلَمْ يُولَدْ"),
                Ayah(4, "وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ"),
            ],
            target: 3
        ),
        // Sūrat al-Falaq — recited three times.
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            ayat: [
                Ayah(nil, "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ"),
                Ayah(1, "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ"),
                Ayah(2, "مِنْ شَرِّ مَا خَلَقَ"),
                Ayah(3, "وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ"),
                Ayah(4, "وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ"),
                Ayah(5, "وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ"),
            ],
            target: 3
        ),
        // Sūrat al-Nās — recited three times.
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
            ayat: [
                Ayah(nil, "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ"),
                Ayah(1, "قُلْ أَعُوذُ بِرَبِّ النَّاسِ"),
                Ayah(2, "مَلِكِ النَّاسِ"),
                Ayah(3, "إِلَهِ النَّاسِ"),
                Ayah(4, "مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ"),
                Ayah(5, "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ"),
                Ayah(6, "مِنَ الْجِنَّةِ وَالنَّاسِ"),
            ],
            target: 3
        ),
        // Sayyid al-Istighfār — the master of seeking forgiveness.
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
            arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
            target: 1
        ),
        // Entering the morning upon the natural disposition of Islam.
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
            arabicText: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ وَشَرِّ مَا بَعْدَهُ",
            target: 1
        ),
        // Seeking well-being in religion, worldly life, family, and wealth.
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
            arabicText: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي",
            target: 1
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
            arabicText: "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ، عَلَيْهِ تَوَكَّلْتُ، وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ",
            target: 7
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
            arabicText: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            target: 3
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-00000000000a")!,
            arabicText: "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
            target: 3
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-00000000000b")!,
            arabicText: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ",
            target: 1
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-00000000000c")!,
            arabicText: "أَصْبَحْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ",
            target: 1
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-00000000000d")!,
            arabicText: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            target: 100
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-00000000000e")!,
            arabicText: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            target: 10
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-00000000000f")!,
            arabicText: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ",
            target: 3
        ),
        Dhikr(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!,
            arabicText: "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
            target: 10
        ),
    ]

    private static let eveningAdhkar: [Dhikr] = [
        // Āyat al-Kursī (al-Baqarah 2:255) — recited once in the evening.
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!,
            ayat: [
                Ayah(nil, "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ"),
                Ayah(255, "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ، لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ، لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ، مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ، يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ، وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ، وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ، وَلَا يَؤُودُهُ حِفْظُهُمَا، وَهُوَ الْعَلِيُّ الْعَظِيمُ"),
            ],
            target: 1
        ),
        // Sūrat al-Ikhlāṣ — recited three times.
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000002")!,
            ayat: [
                Ayah(nil, "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ"),
                Ayah(1, "قُلْ هُوَ اللَّهُ أَحَدٌ"),
                Ayah(2, "اللَّهُ الصَّمَدُ"),
                Ayah(3, "لَمْ يَلِدْ وَلَمْ يُولَدْ"),
                Ayah(4, "وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ"),
            ],
            target: 3
        ),
        // Sūrat al-Falaq — recited three times.
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000003")!,
            ayat: [
                Ayah(nil, "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ"),
                Ayah(1, "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ"),
                Ayah(2, "مِنْ شَرِّ مَا خَلَقَ"),
                Ayah(3, "وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ"),
                Ayah(4, "وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ"),
                Ayah(5, "وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ"),
            ],
            target: 3
        ),
        // Sūrat al-Nās — recited three times.
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000004")!,
            ayat: [
                Ayah(nil, "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ"),
                Ayah(1, "قُلْ أَعُوذُ بِرَبِّ النَّاسِ"),
                Ayah(2, "مَلِكِ النَّاسِ"),
                Ayah(3, "إِلَهِ النَّاسِ"),
                Ayah(4, "مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ"),
                Ayah(5, "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ"),
                Ayah(6, "مِنَ الْجِنَّةِ وَالنَّاسِ"),
            ],
            target: 3
        ),
        // Sayyid al-Istighfār — the master of seeking forgiveness.
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000005")!,
            arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
            target: 1
        ),
        // Entering the evening upon the natural disposition of Islam.
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000006")!,
            arabicText: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ وَشَرِّ مَا بَعْدَهَا",
            target: 1
        ),
        // Seeking well-being in religion, worldly life, family, and wealth.
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000007")!,
            arabicText: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي",
            target: 1
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000008")!,
            arabicText: "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ، عَلَيْهِ تَوَكَّلْتُ، وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ",
            target: 7
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000009")!,
            arabicText: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            target: 3
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-00000000000a")!,
            arabicText: "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
            target: 3
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-00000000000b")!,
            arabicText: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ",
            target: 1
        ),
        // Seeking refuge from the evil of what He created — the evening dhikr.
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-00000000000c")!,
            arabicText: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            target: 3
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-00000000000d")!,
            arabicText: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            target: 100
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-00000000000e")!,
            arabicText: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            target: 10
        ),
        Dhikr(
            id: UUID(uuidString: "10000000-0000-0000-0000-00000000000f")!,
            arabicText: "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
            target: 10
        ),
    ]
}
