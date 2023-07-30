//
//  ChargerFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

enum ChargerFilter {

    case ratedOutputkW
    case ratedOutputVoltage
    case ratedOutputCurrent
    case chargeMethod
    case tetheredCable

    func displayName(_ key: ChargerFilter) -> String {
        switch key {
            case .ratedOutputkW:
                return "Rated Output kW"
            case .ratedOutputVoltage:
                return "Rated Output Voltage"
            case .ratedOutputCurrent:
                return "Rated Output Current"
            case .chargeMethod:
                return "Charge Method"
            case .tetheredCable:
                return "Tethered Cable"
        }
    }
}
