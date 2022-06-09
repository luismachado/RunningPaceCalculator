//
//  Units.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 07/06/2022.
//

import Foundation

enum Units: String, CaseIterable {
    typealias L = Localized.Units

    case kilometers
    case miles

    init?(title: String) {
        guard let unit = Self.allCases.first(where: { $0.title == title }) else {
            return nil
        }

        self = unit
    }

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

    static var allUnits: [String] {
        Self.allCases.map { $0.title }
    }
}
