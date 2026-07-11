//
//  DeepLinkBus.swift
//  PublicSector
//
//  Created by Hamza Jadid on 11/07/2026.
//

import Dependencies
import Foundation

/// A one-way channel for deep links that originate outside the TCA store — today,
/// notification taps handled in `AppDelegate`. The delegate `send`s a route; the
/// root view subscribes to `routes` and forwards each into the store.
///
/// This keeps `AppDelegate` free of a direct store reference and keeps the hand-off
/// testable: a test can drive `send` and observe `routes`.
struct DeepLinkBus: Sendable {
    var send: @Sendable (RootRoute) -> Void
    var routes: @Sendable () -> AsyncStream<RootRoute>
}

extension DeepLinkBus: DependencyKey {
    static let liveValue: DeepLinkBus = {
        let (stream, continuation) = AsyncStream<RootRoute>.makeStream()
        return DeepLinkBus(
            send: { continuation.yield($0) },
            routes: { stream }
        )
    }()
}

extension DeepLinkBus: TestDependencyKey {
    static let testValue = DeepLinkBus(
        send: unimplemented("DeepLinkBus.send"),
        routes: unimplemented("DeepLinkBus.routes", placeholder: .finished)
    )
}

extension DependencyValues {
    var deepLinkBus: DeepLinkBus {
        get { self[DeepLinkBus.self] }
        set { self[DeepLinkBus.self] = newValue }
    }
}
