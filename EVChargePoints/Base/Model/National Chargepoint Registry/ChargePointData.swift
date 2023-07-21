//
//  NetworkManager.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//
//   let chargePointData = try? JSONDecoder().decode(ChargePointData.self, from: jsonData)

import Foundation
import Observation

// MARK: - ChargePointData

struct ChargePointData: Decodable {
    let scheme: Scheme
    var chargeDevices: [ChargeDevice]

    enum CodingKeys: String, CodingKey {
        case scheme         = "Scheme"
        case chargeDevices  = "ChargeDevice"
    }
}

// MARK: - Scheme

struct Scheme: Decodable {
    var schemeCode: String
    var schemeData: SchemeData

    enum CodingKeys: String, CodingKey {
        case schemeCode = "SchemeCode"
        case schemeData = "SchemeData"
    }
}

// MARK: - SchemeData

struct SchemeData: Decodable {
    var organisationName: String
    var website: String
    var telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName  = "OrganisationName"
        case website           = "Website"
        case telephoneNo       = "TelephoneNo"
    }
}

