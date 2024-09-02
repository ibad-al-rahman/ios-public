//
//  DeveloperButtonView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 24/08/2024.
//

import ComposableArchitecture
import SwiftUI

struct DeveloperButtonView: View {
    @Bindable var store: StoreOf<DeveloperButtonFeature>
    @GestureState private var gestureOffset: CGSize = .zero

    var body: some View {
        buttonContent
    }

    @ViewBuilder
    private var buttonContent: some View {
#if DEBUG
        Button(action: { store.send(.onTapDeveloperButton) }) {
            Image(systemName: "wrench.and.screwdriver")
                .frame(width: 55, height: 55)
                .background(.ultraThickMaterial)
                .clipShape(.circle)
                .overlay(border)
        }
        .offset(store.offset)
        .offset(gestureOffset)
        .highPriorityGesture(dragGesture)
        .sheet(
            item: $store.scope(
                state: \.destination?.developerMenu,
                action: \.dependent.destination.developerMenu
            )
        ) {
            DeveloperMenuView(store: $0)
        }
#endif
    }

    private var border: some View {
        Circle()
            .strokeBorder(.primary)
            .clipShape(Circle())
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .updating($gestureOffset) { value, gestureState, _ in
                gestureState = value.translation
            }
            .onEnded {
                store.send(.onGestureEnd(translation: $0.translation))
            }
    }
}

#Preview {
    DeveloperButtonView(store: .init(
        initialState: DeveloperButtonFeature.State(),
        reducer: DeveloperButtonFeature.init
    ))
}
