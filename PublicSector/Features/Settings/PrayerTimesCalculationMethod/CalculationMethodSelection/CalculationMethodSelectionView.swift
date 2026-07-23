//
//  CalculationMethodSelectionView.swift
//  PublicSector
//
//  Created by Hamza Jadid on 23/07/2026.
//

import ComposableArchitecture
import MiqatKit
import SwiftUI

struct CalculationMethodSelectionView: View {
    @Bindable var store: StoreOf<CalculationMethodSelectionFeature>

    var body: some View {
        Form {
            if let preview = store.preview {
                Section("preview") {
                    PrayerTimePreviewRow(prayer: .fajr, time: preview.fajr)
                    PrayerTimePreviewRow(prayer: .ishaa, time: preview.ishaa)
                }
            }
            locationSection
            astronomicalMethodPicker
            if store.astronomicalMethod == .custom {
                customAngleSection
            }
        }
        .navigationTitle("astronomical_method")
        .onAppear { store.send(.view(.onAppear)) }
        .sheet(item: $store.scope(
            state: \.destination?.locationSearch,
            action: \.dependent.destination.locationSearch
        )) { store in
            NavigationStack {
                LocationSearchView(store: store)
            }
        }
    }

    private var locationSection: some View {
        Section {
            if let location = store.selectedLocation?.name {
                NavigationRowView("location", badge: location, systemName: "location")
                    .onTapGesture { store.send(.view(.locationSearchTapped)) }
            } else {
                NavigationRowView("location", systemName: "location")
                    .onTapGesture { store.send(.view(.locationSearchTapped)) }
            }
        } footer: {
            if !store.isAstronomicalConfigurable {
                Text("select_location_first")
            }
        }
    }

    private var astronomicalMethodPicker: some View {
        Picker(selection: $store.astronomicalMethod) {
            ForEach(CalculationMethodSelectionFeature.AstronomicalMethodSelection.allCases) { selection in
                VStack(alignment: .leading, spacing: Spacing.extraExtraSmall) {
                    Text(selection.string)
                    if let caption = selection.caption {
                        Text(caption)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .tag(selection)
            }
        } label: {
            Spacer(minLength: Spacing.small)
        }
        .pickerStyle(.inline)
        .disabled(!store.isAstronomicalConfigurable)
    }

    private var customAngleSection: some View {
        Section {
            HStack(spacing: Spacing.small) {
                angleWheel("custom_fajr_angle", selection: $store.customFajrAngle)
                angleWheel("custom_ishaa_angle", selection: $store.customIshaaAngle)
            }
        } header: {
            Text("custom_provider")
        }
        .disabled(!store.isAstronomicalConfigurable)
    }

    private func angleWheel(
        _ title: LocalizedStringKey,
        selection: Binding<Double>
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.extraExtraSmall) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Picker(title, selection: selection) {
                ForEach(customAngleOptions, id: \.self) { angle in
                    Text(angle.angleLabel).tag(angle)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity)
        }
    }

    /// Discrete selectable twilight angles, derived from the feature's range/step constants.
    private var customAngleOptions: [Double] {
        stride(
            from: CalculationMethodSelectionFeature.customAngleRange.lowerBound,
            through: CalculationMethodSelectionFeature.customAngleRange.upperBound,
            by: CalculationMethodSelectionFeature.customAngleStep
        ).map { $0 }
    }
}

extension Miqat.Method: @retroactive CaseIterable {
    public static var allCases: [Miqat.Method] {
        [.muslimWorldLeague, .egyptian, .ummAlQura, .moonsightingCommittee, .northAmerica, .singapore]
    }

    /// Stable, non-localized identifier used for tags and `Identifiable` conformance.
    var identifier: String {
        switch self {
        case .muslimWorldLeague: "muslimWorldLeague"
        case .egyptian: "egyptian"
        case .ummAlQura: "ummAlQura"
        case .moonsightingCommittee: "moonsightingCommittee"
        case .northAmerica: "northAmerica"
        case .singapore: "singapore"
        }
    }

    var string: String {
        switch self {
        case .muslimWorldLeague: String(localized: "method_muslim_world_league")
        case .egyptian: String(localized: "method_egyptian")
        case .ummAlQura: String(localized: "method_umm_al_qura")
        case .moonsightingCommittee: String(localized: "method_moonsighting_committee")
        case .northAmerica: String(localized: "method_north_america")
        case .singapore: String(localized: "method_singapore")
        }
    }
}

extension CalculationMethodSelectionFeature.AstronomicalMethodSelection {
    /// A short summary of the method's twilight parameters, shown under its row.
    var caption: String? {
        switch self {
        case let .preset(method):
            let params = Miqat.parametersForMethod(method: method)
            let fajr = "\(String(localized: "caption_fajr")) \(params.fajrAngle.angleLabel)"
            // Interval-based Ishaa (e.g. Umm al-Qura) reads back as a 0° angle.
            let ishaa = params.ishaaAngle > 0
                ? "\(String(localized: "caption_ishaa")) \(params.ishaaAngle.angleLabel)"
                : "\(String(localized: "caption_ishaa")) \(String(localized: "caption_interval"))"
            return "\(fajr) · \(ishaa)"
        case .custom:
            return nil
        }
    }
}

private extension Double {
    /// Formats a twilight angle, dropping a trailing `.0` (e.g. `18°`, `18.5°`).
    var angleLabel: String {
        let formatted = truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", self)
            : String(format: "%.1f", self)
        return "\(formatted)°"
    }
}

#Preview {
    NavigationStack {
        CalculationMethodSelectionView(store: Store(
            initialState: CalculationMethodSelectionFeature.State(),
            reducer: CalculationMethodSelectionFeature.init
        ))
    }
}
