//
//  VM+DistanceFormatting.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 27/07/2023.
//

import Foundation

// MARK: - Distance Formatting

extension ChargePointViewModel {

    /// Returns a formatted distance string
    /// - Parameters:
    ///   - distance: the distance from the user to the device
    ///   - unit: the Endpoint.RegistryDataType.Unit
    /// - Returns: String of the formatted distance in km or miles
    func getFormattedDistance(distance: Double, unit: Endpoint.RegistryDataType.Unit) -> String {
        let distanceMeters = Measurement(value: distance, unit: UnitLength.meters)

        switch unit {
            case .mi:
                let distanceMiles = distanceMeters.converted(to: UnitLength.miles).value
                return Decimal(distanceMiles).formatted(
                    .number.precision(.fractionLength(0...2))
                ) + " " + unit.rawValue

            case .km:
                let distanceKm = distanceMeters.converted(to: UnitLength.kilometers).value
                return Decimal(distanceKm).formatted(
                    .number.precision(.fractionLength(0...2))
                ) + " " + unit.rawValue
        }
    }
}
