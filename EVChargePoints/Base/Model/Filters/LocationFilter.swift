//
//  LocationFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

enum LocationFilter {

    case dealershipForecourt
    case educationalEstablishment
    case hotelAccommodation
    case leisureCentre
    case nhsProperty
    case onStreet
    case other
    case parkRideSite
    case privateHome
    case publicCarPark
    case publicEstate
    case retailCarPark
    case serviceStation
    case workplaceCarPark

    func displayName(_ key: LocationFilter) -> String {
        switch key {
            case .dealershipForecourt:
                return "Dealership Forecourt"
            case .educationalEstablishment:
                return "Educational Establishment"
            case .hotelAccommodation:
                return "Hotel / Accommodation"
            case .leisureCentre:
                return "Leisure Centre"
            case .nhsProperty:
                return "NHS Property"
            case .other:
                return "Other"
            case .onStreet:
                return "On-Street"
            case .parkRideSite:
                return "Park & Ride Site"
            case .privateHome:
                return "Private Home"
            case .publicCarPark:
                return "Public Car Park"
            case .publicEstate:
                return "Public Estate"
            case .retailCarPark:
                return "Retail Car Park"
            case .serviceStation:
                return "Service Station"
            case .workplaceCarPark:
                return "Workplace Car Park"
        }
    }

//    func values(_ key: ChargerType) ->
}
