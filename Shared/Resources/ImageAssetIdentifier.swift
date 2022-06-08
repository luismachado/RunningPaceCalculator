//
//  ImageAssetIdentifier.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 06/06/2022.
//

import Foundation
import Xcore

extension ImageAssetIdentifier {
    private static func propertyName(_ name: String = #function, accessibilityLabel: String? = nil) -> Self {
        .init(rawValue: name, bundle: BundleToken.bundle, accessibilityLabel: accessibilityLabel)
    }
}

extension ImageAssetIdentifier {
    static var cog: Self { propertyName() }
    static var erase: Self { propertyName() }
}

