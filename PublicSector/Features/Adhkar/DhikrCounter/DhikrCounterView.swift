//
//  DhikrCounterView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 06/03/2026.
//

import ComposableArchitecture
import SwiftUI

struct DhikrCounterView: View {
    @Bindable var store: StoreOf<DhikrCounterFeature>

    var body: some View {
        VStack(spacing: Spacing.large) {
            Spacer()

            Text(store.dhikr.ar)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.large)

            Spacer()

            counterButton

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Reset") { store.send(.onReset, animation: .spring(duration: 0.3)) }
                    .disabled(store.remaining == store.dhikr.count)
            }
        }
    }

    private var counterButton: some View {
        Button {
            store.send(.onTap, animation: .spring(duration: 0.3))
        } label: {
            ZStack {
                Circle()
                    .fill(store.isDone ? Color.green.opacity(0.15) : Color.accentColor.opacity(0.1))
                    .frame(width: 200, height: 200)

                if store.isDone {
                    Image(systemName: "checkmark")
                        .font(.system(size: 64, weight: .light))
                        .foregroundStyle(.green)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text("\(store.remaining)")
                        .font(.system(size: 64, weight: .light, design: .rounded))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText(countsDown: true))
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(store.isDone)
    }
}

#Preview {
    NavigationStack {
        DhikrCounterView(store: Store(
            initialState: DhikrCounterFeature.State(dhikr: AdhkarData.morning[0]),
            reducer: DhikrCounterFeature.init
        ))
    }
}

#Preview {
    NavigationStack {
        DhikrCounterView(store: Store(
            initialState: DhikrCounterFeature.State(dhikr: AdhkarData.morning[7]),
            reducer: DhikrCounterFeature.init
        ))
    }
    .arabicEnvironment()
}
