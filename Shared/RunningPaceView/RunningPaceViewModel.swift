//
//  RunningPaceViewModel.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 06/06/2022.
//

import Foundation
import SwiftUI

public enum RowType {
    typealias L = Localized.RowType

    case time
    case distance
    case pace

    var title: String {
        switch self {
            case .time:
                return L.time
            case .distance:
                return L.distance
            case .pace:
                return L.pace
        }
    }
}

final class RunningPaceViewModel: ObservableObject {
    @Published var timeHourValue: String = ""
    @Published var timeMinutesValue: String = ""
    @Published var timeSecondsValue: String = ""
    @Published var distanceValue: String = ""
    @Published var paceMinuteValue: String = ""
    @Published var paceSecondsValue: String = ""

    // When we try to calculate the requested value and necessary values are
    // empty, we need to highlight them.
    @Published var missingFields: [RowType] = []
    @Published var showMissingFieldsAlert: Bool = false

    var missingFieldsAlertMessage: String? {
        guard !missingFields.isEmpty else {
            return nil
        }

        return missingFields
            .map { $0.title }
            .joined(separator: " and ")
            .appending(" not filled.")
    }

    private func alertAboutMissingFields(required: [RowType]) {
        self.missingFields.removeAll()

        required.forEach {
            switch $0 {
                case .time:
                    if timeSeconds.isNil {
                        self.missingFields.append(.time)
                    }
                case .distance:
                    if distance.isNil {
                        self.missingFields.append(.distance)
                    }
                case .pace:
                    if paceSeconds.isNil {
                        self.missingFields.append(.pace)
                    }
            }
        }

        showMissingFieldsAlert = !self.missingFields.isEmpty
    }

    var distanceUnit: Units {
        UDWrapper.live.getDistanceUnits()
    }

    private var paceSeconds: Double? {
        getSecondsFrom(hours: "", minutes: paceMinuteValue, seconds: paceSecondsValue)
    }

    private var timeSeconds: Double? {
        getSecondsFrom(hours: timeHourValue, minutes: timeMinutesValue, seconds: timeSecondsValue)
    }

    private var distance: Double? {
        let distanceWithDot = distanceValue.replacingOccurrences(of: ",", with: ".")
        return Double(distanceWithDot)
    }

    public func eraseFields(for kind: RowType) {
        switch kind {
            case .time:
                timeHourValue = ""
                timeMinutesValue = ""
                timeSecondsValue = ""
            case .distance:
                distanceValue = ""
            case .pace:
                paceMinuteValue = ""
                paceSecondsValue = ""
        }
    }

    public func setDistanceFromPicker(stringValue: String) {
        if let selectedDistanceNormalized = Distance(title: stringValue) {
            self.distanceValue = String(selectedDistanceNormalized.distance)
        }
    }

    public func calculate(kind: RowType) {
        missingFields.removeAll()

        switch kind {
            case .time:
               calculateTime()
            case .distance:
                calculateDistance()
            case .pace:
                calculatePace()
        }
    }

    private func calculateTime() {
        guard
            let distance = distance,
            let paceSeconds = paceSeconds
        else {
            alertAboutMissingFields(required: [.distance, .pace])
            return
        }

        let timeInSeconds = distance * paceSeconds
        let hours = Int(timeInSeconds / 3600)
        let minutes = Int(timeInSeconds.truncatingRemainder(dividingBy: 3600)/60)
        let seconds = Int(timeInSeconds.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))

        self.timeHourValue = String(hours)
        self.timeMinutesValue = String(minutes)
        self.timeSecondsValue = String(seconds)
    }

    private func calculateDistance() {
        guard
            let timeSeconds = timeSeconds,
            let paceSeconds = paceSeconds
        else {
            alertAboutMissingFields(required: [.time, .pace])
            return
        }

        let roundDistance = Double(round(1000 * timeSeconds / paceSeconds) / 1000)
        self.distanceValue = String(roundDistance)
    }

    private func calculatePace() {
        guard
            let timeSeconds = timeSeconds,
            let distance = distance
        else {
            alertAboutMissingFields(required: [.time, .distance])
            return
        }

        let timeInSeconds = timeSeconds / distance
        let minutes = Int(timeInSeconds/60)
        let seconds = Int(timeInSeconds.truncatingRemainder(dividingBy: 60))

        self.paceMinuteValue = String(minutes)
        self.paceSecondsValue = String(seconds)
    }
}

extension RunningPaceViewModel {
    private func getSecondsFrom(hours: String, minutes: String, seconds: String) -> Double? {
        if hours == "" && minutes == "" && seconds == "" {
            return nil
        }

        var hoursValue: Double = 0
        var minutesValue: Double = 0
        var secondsValue: Double = 0

        if hours != "" {
            if let hoursDouble = Double(hours) {
                hoursValue = hoursDouble
            }
        }

        if minutes != "" {
            if let minutesDouble = Double(minutes) {
                minutesValue = minutesDouble
            }
        }

        if seconds != "" {
            if let secondsDouble = Double(seconds) {
                secondsValue = secondsDouble
            }
        }

        let total = (hoursValue*60*60) + (minutesValue*60) + secondsValue

        // Let's make sure it isn't zero (avoid dividing by zero)
        if total == 0 {
            return nil
        }

        return total
    }
}
