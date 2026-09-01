//
//  Istikhara.swift
//  PublicSector
//
//  Created by Hamza Jadid on 01/09/2026.
//

import SwiftUI

/// The duaa of Istikhara (صلاة الاستخارة) — recited when seeking guidance on a
/// decision. The canonical wording (Bukhari) leaves the specific matter open: the
/// worshipper names the thing they are deciding on. `placeholder` marks the two
/// positions where that matter is spoken; `filled(with:)` substitutes the user's
/// decision inline at both, or leaves the neutral placeholder in place when no
/// decision is given.
///
/// The Arabic text is verbatim and never localized, consistent with `Dhikr.arabicText`.
enum Istikhara {
    /// The neutral placeholder standing in for the matter being decided ("this
    /// matter"). Appears twice in `text`.
    static let placeholder = "هَٰذَا الْأَمْرَ"

    /// The full duaa, with `placeholder` at the two spots where the matter is named.
    static let text = """
    اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ، وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ، وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ، فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ، وَتَعْلَمُ وَلَا أَعْلَمُ، وَأَنْتَ عَلَّامُ الْغُيُوبِ. اللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ \(placeholder) خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي، فَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيهِ، وَإِنْ كُنْتَ تَعْلَمُ أَنَّ \(placeholder) شَرٌّ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي، فَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ، وَاقْدُرْ لِيَ الْخَيْرَ حَيْثُ كَانَ ثُمَّ أَرْضِنِي بِهِ.
    """

    /// The duaa with the worshipper's decision substituted at both placeholder
    /// positions, the decision emphasized (bold) so it stands out from the duaa. A
    /// `nil` or blank decision leaves the neutral placeholder wording intact — still a
    /// valid duaa, with the placeholder itself emphasized.
    static func attributed(with decision: String?) -> AttributedString {
        let matter = decision?.trimmingCharacters(in: .whitespacesAndNewlines)
        let emphasis = (matter?.isEmpty == false) ? matter! : placeholder

        // Split around every placeholder occurrence so each in-between run stays plain
        // and each `emphasis` run is bolded.
        var result = AttributedString()
        let segments = text.components(separatedBy: placeholder)
        for (index, segment) in segments.enumerated() {
            result += AttributedString(segment)
            if index < segments.count - 1 {
                var emphasized = AttributedString(emphasis)
                emphasized.inlinePresentationIntent = .stronglyEmphasized
                result += emphasized
            }
        }
        return result
    }
}
