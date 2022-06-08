//
//  Button+Style.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 07/06/2022.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        let currentForegroundColor = configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor
        return configuration.label
            .padding(6)
            .foregroundColor(currentForegroundColor)
            .background(backgroundColor)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(backgroundColor)

            )
            .shadow()
    }
}

struct CustomButton: View {
    private var backgroundColor: Color
    private var foregroundColor: Color
    private let title: String
    private let action: () -> Void

    init(
        title: String,
        backgroundColor: Color = AppConstants.accentColor,
        foregroundColor: Color = Color.white,
        action: @escaping () -> Void
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action:self.action) {
            Text(self.title)
        }
        .buttonStyle(
            CustomButtonStyle(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor
            )
        )
    }
}
