//
//  CustomTextField.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 08/06/2022.
//

import SwiftUI
import Combine

public struct CustomTextField: View {
    private let placeholder: String
    private let text: Binding<String>
    private let keyboardType: UIKeyboardType
    private let width: CGFloat
    private let hightlightError: Bool

    public init(
        _ placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .numberPad,
        width: CGFloat = 50,
        hightlightError: Bool = false
    ) {
        self.placeholder = placeholder
        self.text = text
        self.keyboardType = keyboardType
        self.width = width
        self.hightlightError = hightlightError
    }

    public var body: some View {
        TextField(placeholder, text: text)
            .applyIf(hightlightError) {
                $0.textFieldStyle(ErrorTextFieldStyle())
            }
            .applyIf(!hightlightError) {
                $0.textFieldStyle(CustomTextFieldStyle())
            }
            .keyboardType(keyboardType)
            .frame(width: width)
            .onReceive(Just(text.wrappedValue)) { newValue in
                let filtered = newValue.filter { "0123456789.".contains($0) }
                if filtered != newValue {
                    text.wrappedValue = filtered
                }
            }
    }
}
