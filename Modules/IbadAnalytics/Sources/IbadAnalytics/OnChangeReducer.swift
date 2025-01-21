//
//  OnChangeReducer.swift
//  IbadAnalytics
//
//  Created by Hamza Jadid on 21/01/2025.
//

import Foundation
import ComposableArchitecture

extension Reducer {
    @inlinable
    public func analyticsOnChange<V: Equatable & Sendable>(
        of toValue: @Sendable @escaping (State) -> V,
        _ toAnalyticsData: @Sendable @escaping (V, V) -> AnalyticsData
    ) -> _OnChangeAnalyticsReducer<Self, V> {
        _OnChangeAnalyticsReducer(
            base: self,
            toValue: toValue,
            toAnalyticsData: toAnalyticsData
        )
    }
}

public struct _OnChangeAnalyticsReducer<Base: Reducer & Sendable, Value: Equatable & Sendable>: Reducer, Sendable {
    @usableFromInline
    let base: Base

    @usableFromInline
    let toValue: @Sendable (Base.State) -> Value

    @usableFromInline
    @Dependency(\.analyticsClient) var analyticsClient

    @usableFromInline
    let toAnalyticsData: @Sendable (Value, Value) -> AnalyticsData

    @usableFromInline
    init(
        base: Base,
        toValue: @Sendable @escaping (Base.State) -> Value,
        toAnalyticsData: @Sendable @escaping (Value, Value) -> AnalyticsData
    ) {
        self.base = base
        self.toValue = toValue
        self.toAnalyticsData = toAnalyticsData
    }

    @inlinable
    public func reduce(into state: inout Base.State, action: Base.Action) -> Effect<Base.Action> {
        let oldValue = toValue(state)
        let effects = self.base.reduce(into: &state, action: action)
        let newValue = toValue(state)

        return oldValue == newValue
        ? effects
        : effects.merge(with: .run { _ in analyticsClient.sendAnalytics(toAnalyticsData(oldValue, newValue)) })
    }
}
