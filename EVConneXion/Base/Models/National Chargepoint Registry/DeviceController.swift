//
//  DeviceController.swift
//  EVConneXion
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

// MARK: - DeviceController

struct DeviceController: Decodable {
    var organisationName: String
    var schemeCode: String
    var website: String
    var telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName  = "OrganisationName"
        case schemeCode        = "SchemeCode"
        case website           = "Website"
        case telephoneNo       = "TelephoneNo"
    }
}
