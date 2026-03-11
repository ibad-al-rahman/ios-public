// The Swift Programming Language
// https://docs.swift.org/swift-book

import Miqat
import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct MiqatService: Sendable {
    public var getMiqatData: @Sendable (
        _ timestampSecs: TimeInterval, _ provider: Provider
    ) -> MiqatData = { MiqatData(timestampSecs: $0, provider: $1) }
}

extension MiqatService: DependencyKey {
    public static var liveValue: MiqatService {
        return MiqatService(
            getMiqatData: { MiqatData(timestampSecs: $0, provider: $1) }
        )
    }
}

extension MiqatService: TestDependencyKey {
    public static var previewValue: MiqatService {
        MiqatService()
    }

    public static var testValue: MiqatService {
        MiqatService()
    }
}

public extension DependencyValues {
    var miqatService: MiqatService {
        get { self[MiqatService.self] }
        set { self[MiqatService.self] = newValue }
    }
}
