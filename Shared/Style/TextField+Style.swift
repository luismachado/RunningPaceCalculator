//
//  TextField+Style.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 08/06/2022.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .backgroundColor(.white)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(UIColor.lightGray), lineWidth: 0.2)
            )
    }
}

struct ErrorTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .backgroundColor(.red.opacity(0.3))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.red, lineWidth: 0.2)
            )
    }
}
