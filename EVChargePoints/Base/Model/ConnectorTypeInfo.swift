//
//  ConnectorTypeInfo.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 14/07/2023.
//

import Foundation

struct ConnectorTypeInfo: Decodable {

    let connectorTypeID: Int
    let name: String
    let displayName: String
    let chargeMethod: String
    let chargeMode: Int

    enum CodingKeys: String, CodingKey {
        case connectorTypeID  = "ConnectorTypeID"
        case name             = "Name"
        case displayName      = "DisplayName"
        case chargeMethod     = "ChargeMethod"
        case chargeMode       = "ChargeMode"
    }
}
