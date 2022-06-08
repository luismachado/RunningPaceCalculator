//
//  Units.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 07/06/2022.
//

import Foundation

enum Units: String {
    typealias L = Localized.Units

    case kilometers
    case miles

    var title: String {
        switch self {
            case .kilometers:
                return L.Kilometers.title
            case .miles:
                return L.Miles.title
        }
    }

    var shortened: String {
        switch self {
            case .kilometers:
                return L.Kilometers.shortened
            case .miles:
                return L.Miles.shortened
        }
    }
}
