//
//  Store+BaseFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

public extension ComposableArchitecture.Store where Action: BaseAction {
    /// TCA Action Boundary extension for sending BaseAction ViewAction
    @discardableResult
    func send(_ action: Action.ViewAction) -> StoreTask {
        send(.view(action))
    }

    /// TCA Action Boundary extension for sending BaseAction ViewAction with Animation
    @discardableResult
    func send(_ action: Action.ViewAction, animation: Animation) -> StoreTask {
        send(.view(action), animation: animation)
    }

    /// TCA Action Boundary extension for sending BaseAction ViewAction with Transaction
    @discardableResult
    func send(_ action: Action.ViewAction, transaction: Transaction) -> StoreTask {
        send(.view(action), transaction: transaction)
    }
}
