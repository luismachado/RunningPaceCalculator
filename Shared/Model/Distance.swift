//
//  Distance.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 08/06/2022.
//

import Foundation

enum Distance: CaseIterable {
    typealias L = Localized.Distance

    case fiveK
    case tenK
    case halfMarathon
    case marathon

    init?(title: String) {
        guard let distance = Self.allCases.first(where: { $0.title == title }) else {
            return nil
        }

        self = distance
    }

    var title: String {
        switch self {
            case .fiveK:
                return L.Title.fiveK
            case .tenK:
                return L.Title.tenK
            case .halfMarathon:
                return L.Title.halfMarathon
            case .marathon:
                return L.Title.marathon
        }
    }

    var distance: Double {
        switch self {
            case .fiveK:
                return 5.000
            case .tenK:
                return 10.000
            case .halfMarathon:
                return 21.098
            case .marathon:
                return 42.196
        }
    }

    static var allDistances: [String] {
        Self.allCases.map { $0.title }
    }
}
