import Dependencies
import Foundation

public struct ApplicationDetails: Sendable {
    public let versionString: String
    public var buildString: String
}

extension ApplicationDetails: DependencyKey {
    public static var liveValue: ApplicationDetails {
        guard let versionString = Bundle
            .main
            .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        else { fatalError("bundle version string is not defined") }

        guard let buildString = Bundle
            .main
            .object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else { fatalError("build number not defined") }

        return ApplicationDetails(
            versionString: versionString,
            buildString: buildString
        )
    }
}

extension ApplicationDetails: TestDependencyKey {
    public static var testValue: ApplicationDetails {
        ApplicationDetails(
            versionString: "99.12.31",
            buildString: "9999"
        )
    }

    public static var previewValue: ApplicationDetails {
        ApplicationDetails(
            versionString: "99.12.31",
            buildString: "9999"
        )
    }
}

public extension DependencyValues {
    var appDetails: ApplicationDetails {
        get { self[ApplicationDetails.self] }
        set { self[ApplicationDetails.self] = newValue }
    }
}
