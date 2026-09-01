//
//  IstikharaView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 01/09/2026.
//

import ComposableArchitecture
import IbadDesign
import SwiftUI

/// The Istikhara duaa, personalized with the user's decision. On launch a native
/// alert prompts for that decision; once confirmed the duaa is shown centered, with
/// the decision substituted inline at both placeholder positions.
struct IstikharaView: View {
    @Bindable var store: StoreOf<IstikharaFeature>

    var body: some View {
        VStack(spacing: Spacing.large) {
            Spacer(minLength: Spacing.large)

            Text(store.duaa)
                .font(.system(.title2, design: .serif))
                .multilineTextAlignment(.center)
                .lineSpacing(Spacing.small)
                .foregroundStyle(Color.Ibad.textPrimary)
                .frame(maxWidth: .infinity)

            Spacer(minLength: Spacing.large)
        }
        .padding(.horizontal, Spacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("istikhara")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarItems }
        .onAppear { store.send(.view(.onAppear)) }
        .alert("istikhara_prompt_title", isPresented: $store.isPromptPresented) {
            TextField("istikhara_prompt_placeholder", text: $store.decision)
            Button("continue") { store.send(.view(.onTapConfirm)) }
        } message: {
            Text("istikhara_prompt_message")
        }
    }

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                store.send(.view(.onTapEdit))
            } label: {
                Label("istikhara_edit_decision", systemImage: "pencil")
            }
        }
    }
}

#Preview {
    NavigationStack {
        IstikharaView(store: Store(
            initialState: IstikharaFeature.State(
                isPromptPresented: false,
                confirmedDecision: "قَبُولِ الْعَرْضِ الْوَظِيفِيِّ"
            ),
            reducer: IstikharaFeature.init
        ))
    }
}

#Preview {
    NavigationStack {
        IstikharaView(store: Store(
            initialState: IstikharaFeature.State(
                isPromptPresented: false,
                confirmedDecision: "قَبُولِ الْعَرْضِ الْوَظِيفِيِّ"
            ),
            reducer: IstikharaFeature.init
        ))
    }
    .arabicEnvironment()
}
