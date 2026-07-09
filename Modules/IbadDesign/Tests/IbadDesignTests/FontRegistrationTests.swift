import Testing
import UIKit
@testable import IbadDesign

@Suite struct FontRegistrationTests {
    @Test func registersQuranicFacesFromBundle() {
        // Registration is idempotent; calling twice must not fail.
        IbadDesign.registerFonts()
        IbadDesign.registerFonts()

        #expect(UIFont(name: IbadDesign.FontName.quranicRegular, size: 12) != nil)
        #expect(UIFont(name: IbadDesign.FontName.quranicBold, size: 12) != nil)
    }
}
