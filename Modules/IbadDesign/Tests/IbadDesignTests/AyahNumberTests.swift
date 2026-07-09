import Testing
@testable import IbadDesign

@Suite struct AyahNumberTests {
    @Test func convertsSingleDigitToArabicIndic() {
        #expect(AyahNumber.arabicIndicDigits(1) == "١")
        #expect(AyahNumber.arabicIndicDigits(0) == "٠")
        #expect(AyahNumber.arabicIndicDigits(9) == "٩")
    }

    @Test func convertsMultiDigitToArabicIndic() {
        #expect(AyahNumber.arabicIndicDigits(255) == "٢٥٥")
        #expect(AyahNumber.arabicIndicDigits(10) == "١٠")
    }

    @Test func wrapsNumberInOrnateBrackets() {
        // RTL isolate + right-bracket + digits + left-bracket + pop, so the
        // brackets render as ﴾…﴿ (opening on the reader's right) in an RTL line.
        #expect(AyahNumber.formatted(1) == "\u{2067}\u{FD3F}١\u{FD3E}\u{2069}")
        #expect(AyahNumber.formatted(255) == "\u{2067}\u{FD3F}٢٥٥\u{FD3E}\u{2069}")
    }
}
