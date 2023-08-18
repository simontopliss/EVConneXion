//
//  LocationType.swift
//  EVConneXion
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

// MARK: - LocationType

enum LocationType: String, Codable, CaseIterable {
    case dealershipForecourt            = "Dealership forecourt"
    case educationalEstablishment       = "Educational establishment"
    case hotelAccommodation             = "Hotel / Accommodation"
    case leisureCentre                  = "Leisure centre"
    case nhsProperty                    = "NHS property"
    case onStreet                       = "On-street"
    case other                          = "Other"
    case parkRideSite                   = "Park & Ride site"
    case privateHome                    = "Private home"
    case publicCarPark                  = "Public car park"
    case publicEstate                   = "Public estate"
    case retailCarPark                  = "Retail car park"
    case serviceStation                 = "Service station"
    case workplaceCarPark               = "Workplace car park"
    case unknown
}

// A new type was added over the last few days, and wasn't caught by the above enum
// This seems to be the solution to catch `unknown` types
// https://stackoverflow.com/a/49697266/7429227
extension LocationType {
    init(from decoder: Decoder) throws {
        self = try LocationType(
            rawValue: decoder.singleValueContainer().decode(RawValue.self)
        ) ?? .unknown
    }
}
