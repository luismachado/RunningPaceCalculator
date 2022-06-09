//
//  OptionsView.swift
//  RunningPaceCalculator (iOS)
//
//  Created by Luís Machado on 09/06/2022.
//

import SwiftUI
import Xcore

struct OptionsView: View {
    typealias L = Localized.Options

    let userDefaults: UDWrapper = .live

    @State private var isDistanceUnitsPickerShowing: Bool = false
    @State private var selectedDistanceUnitsPicker: String
    @State private var selectedDistanceUnits: String

    public init() {
        selectedDistanceUnits = userDefaults.getDistanceUnits().title
        selectedDistanceUnitsPicker = userDefaults.getDistanceUnits().title
    }

    private func updateUnitFromUserDefault(newValue: Units? = nil) {
        if let newValue = newValue {
            userDefaults.setDistanceUnits(unit: newValue)
        }

        selectedDistanceUnits = userDefaults.getDistanceUnits().title
    }

    var body: some View {
        List {
            HStack {
                Text(L.Row.distanceUnits)
                Spacer()
                Button {
                    isDistanceUnitsPickerShowing = true
                } label: {
                    Text(selectedDistanceUnits)
                        .foregroundColor(AppConstants.accentColor)
                }
            }
        }
        .backgroundColor(AppConstants.backgroundColor)
        .navigationTitle(L.title)
        .navigationBarTitleDisplayMode(.inline)
        .popup(isPresented: $isDistanceUnitsPickerShowing, style: .sheet) {
            CustomPickerPopup(selection: $selectedDistanceUnitsPicker) {
                ForEach(Units.allUnits, id: \.self) { unit in
                    Text(unit)
                }
            } done: {
                if let selectedDistanceUnit = Units(title: selectedDistanceUnitsPicker) {
                    updateUnitFromUserDefault(newValue: selectedDistanceUnit)
                }
                isDistanceUnitsPickerShowing = false
            }
        }
    }
}
