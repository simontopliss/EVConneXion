//
//  AccessFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

enum AccessFilter {

    case accessible24Hours
    case accessRestriction
    case onStreetParking
    case parkingFees
    case physicalRestriction

    func displayName(_ key: AccessFilter) -> String {
        switch self {
            case .accessible24Hours:
                return "Accessible 24 Hours"
            case .accessRestriction:
                return "Access Restriction"
            case .onStreetParking:
                return "On-Street"
            case .parkingFees:
                return "Parking Fees"
            case .physicalRestriction:
                return "Physical Restriction"
        }
    }
}
