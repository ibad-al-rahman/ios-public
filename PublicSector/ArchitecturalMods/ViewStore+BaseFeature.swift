//
//  ViewStore+BaseFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewAction: BaseAction {
    /// TCA Action Boundary extension for sending ViewActions
    @discardableResult
    public func send(_ action: ViewAction.ViewAction) -> StoreTask {
        self.send(.view(action))
    }

    /// TCA Action Boundary extension for sending ViewActions with animation
    @discardableResult
    public func send(
        _ action: ViewAction.ViewAction,
        animation: Animation?
    ) -> StoreTask {
        self.send(.view(action), animation: animation)
    }

    /// TCA Action Boundary extension for sending ViewActions with transaction
    @discardableResult
    public func send(
        _ action: ViewAction.ViewAction,
        transaction: Transaction
    ) -> StoreTask {
        self.send(.view(action), transaction: transaction)
    }

    /// TCA Action Boundary extension for sending ViewActions with while predicate is true
    @MainActor
    public func send(
        _ action: ViewAction.ViewAction,
        while predicate: @escaping (ViewState) -> Bool
    ) async {
        await self.send(.view(action), while: predicate)
    }
}
