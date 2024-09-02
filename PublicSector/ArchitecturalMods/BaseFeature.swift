//
//  BaseFeature.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture

// Taken from https://www.merowing.info/boundries-in-tca/
public protocol BaseAction {
    associatedtype ViewAction
    associatedtype ReducerAction
    associatedtype DelegateAction
    associatedtype DependentAction

    // Actions triggered by view (user)
    static func view(_: ViewAction) -> Self
    // Actions triggered by reducer, e.g. dataFetched.
    // These may well update state and thus update UI
    // In above article this was called internal
    static func reducer(_: ReducerAction) -> Self
    // Action triggered by reducer to communicate back to a
    // parent reducer to handle
    static func delegate(_: DelegateAction) -> Self
    // Action triggered by child to communicate back to this reducer as its parent
    // e.g. direct child or presented child action sending delegate action to be handled here
    // parent reducer to handle
    static func dependent(_: DependentAction) -> Self
}
