import SwiftUI
import Testing
import UIKit
@testable import IbadDesign

@Suite struct ColorsTests {
    private let light = UITraitCollection(userInterfaceStyle: .light)
    private let dark = UITraitCollection(userInterfaceStyle: .dark)

    @Test func backgroundFlipsBetweenLightAndDark() {
        let color = UIColor(Color.Ibad.background)
        #expect(color.resolvedColor(with: light) != color.resolvedColor(with: dark))
    }

    @Test func accentFlipsBetweenLightAndDark() {
        let color = UIColor(Color.Ibad.accent)
        #expect(color.resolvedColor(with: light) != color.resolvedColor(with: dark))
    }

    @Test func backgroundResolvesToExpectedValues() {
        let color = UIColor(Color.Ibad.background)

        var lightWhite: CGFloat = 0
        color.resolvedColor(with: light).getWhite(&lightWhite, alpha: nil)
        #expect(abs(lightWhite - 1.0) < 0.01)

        var darkWhite: CGFloat = 0
        color.resolvedColor(with: dark).getWhite(&darkWhite, alpha: nil)
        #expect(abs(darkWhite - (0x12 / 255.0)) < 0.01)
    }
}
