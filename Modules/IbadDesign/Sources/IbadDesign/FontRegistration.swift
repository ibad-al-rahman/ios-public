//
//  FontRegistration.swift
//  IbadDesign
//
//  The KFGQPC (Uthman Taha Naskh) font ships inside this package's resource
//  bundle rather than the app bundle, so it is not picked up by the app's
//  `UIAppFonts` Info.plist key. Callers must register it programmatically once
//  at startup via `IbadDesign.registerFonts()` before any `Font.quranic(...)`
//  will resolve.
//

import CoreText
import Foundation

/// Namespace for the design system's package-level entry points.
public enum IbadDesign {
    /// PostScript names the fonts register under, used by callers that resolve
    /// them through `Font.custom` / `UIFont(name:size:)`. These are the fonts'
    /// *internal* PostScript names, which differ from the `.ttf` filenames — the
    /// filenames are hyphenated, the PostScript names are not.
    public enum FontName {
        public static let quranicRegular = "KFGQPCUthmanTahaNaskh"
        public static let quranicBold = "KFGQPCUthmanTahaNaskh-Bold"
    }

    /// The `.ttf` resource base names bundled with the package.
    private static let fontResources = [
        "KFGQPC-Uthman-Taha-Naskh-Regular",
        "KFGQPC-Uthman-Taha-Naskh-Bold",
    ]

    private static let registerOnce: Void = {
        for name in fontResources {
            registerFont(named: name)
        }
    }()

    /// Registers the bundled fonts with Core Text. Idempotent: safe to call
    /// multiple times; the work runs at most once.
    public static func registerFonts() {
        _ = registerOnce
    }

    private static func registerFont(named name: String) {
        guard
            let url = Bundle.module.url(forResource: name, withExtension: "ttf"),
            let dataProvider = CGDataProvider(url: url as CFURL),
            let font = CGFont(dataProvider)
        else {
            assertionFailure("IbadDesign: failed to load bundled font \(name).ttf")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            // Already-registered is not a real failure; anything else is worth surfacing.
            let code = CFErrorGetCode(error?.takeUnretainedValue())
            if code != CTFontManagerError.alreadyRegistered.rawValue {
                assertionFailure("IbadDesign: failed to register font \(name): \(String(describing: error))")
            }
        }
    }
}
