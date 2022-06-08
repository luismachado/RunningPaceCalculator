//
//  View+Extensions.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 07/06/2022.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
#endif

// Tile/Shadow effects
extension View {
    public func shadow() -> some View {
        shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
    }

    public func tiled() -> some View {
        cornerRadius(10)
            .shadow()
    }
}
