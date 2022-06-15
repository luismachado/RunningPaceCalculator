//
//  AppConstants.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 07/06/2022.
//

import SwiftUI

public struct AppConstants {
    public static let accentColor: Color = .init(hex: "17473E")
    public static let backgroundColor: Color = .init(hex: "F6F6F6")

    public static let kmToMilesConstant: Double = 0.621371
}


public struct AdConstants {
    public static let live: Self = .init()

    public var bannerAdId: String {
        let bannerAdId = Bundle.main.object(forInfoDictionaryKey: "GADAdUnitId") as? String
        return bannerAdId ?? ""
    }
}
