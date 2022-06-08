//
//  CustomPicker.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 08/06/2022.
//

import SwiftUI
import Xcore

public struct CustomPickerPopup<Content: View>: View {
    private let selection: Binding<String>
    private let done: () -> Void
    private let pickerContent: () -> Content

    public init(
        selection: Binding<String>,
        @ViewBuilder pickerContent: @escaping () -> Content,
        done: @escaping () -> Void
    ) {
        self.selection = selection
        self.pickerContent = pickerContent
        self.done = done
    }

    public var body: some View {
        PopupSheet {
            Button(action: done) {
                Text("Done")
            }
            .foregroundColor(AppConstants.accentColor)
            .padding(.horizontal, 20)
            .hAlign(.trailing)

            Picker("", selection: selection, content: pickerContent)
                .pickerStyle(.wheel)
                .padding(.horizontal, .defaultSpacing)
        }
    }
}
