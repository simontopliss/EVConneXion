//
//  VM+RegularOpenings.swift
//  EVConneXion
//
//  Created by Simon Topliss on 27/07/2023.
//

import Foundation

extension DataManager {

    func regularOpeningsBuilder(regularOpenings: [RegularOpening]?) -> ([String], [String]) {
        var openingDays: [String] = []
        var openingHours: [String] = []

        if let regularOpenings = regularOpenings {

            for opening in regularOpenings {
                if let days = opening.days {
                    openingDays.append(days)
                }

                if let hours = opening.hours {
                    openingHours.append("\(hours.from) to \(hours.to)")
                }
            }
        }

        return (openingDays, openingHours)
    }

    func openingsDaysFor(regularOpenings: [RegularOpening]) -> [String] {
        var openingDays: [String] = []

        for opening in regularOpenings {
            if let days = opening.days {
                openingDays.append(days)
            }
        }

        return openingDays
    }

    func openingsHoursFor(regularOpenings: [RegularOpening]) -> [String] {
        var openingHours: [String] = []

        for opening in regularOpenings {
            if let hours = opening.hours {
                openingHours.append("\(hours.from) to \(hours.to)")
            }
        }

        return openingHours
    }
}
