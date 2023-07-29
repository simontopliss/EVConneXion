//
//  Connector.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

// MARK: - Connector

struct Connector: Decodable {
    var connectorId: String
    var connectorType: ConnectorType
    var ratedOutputkW: String
    var ratedOutputVoltage: String
    var ratedOutputCurrent: String
    var chargeMethod: ChargeMethod
    var chargeMode: String
    var chargePointStatus: ChargeStatus
    var tetheredCable: TetheredCable
    var information: String?
    var validated: String

    enum CodingKeys: String, CodingKey {
        case connectorId         = "ConnectorId"
        case connectorType       = "ConnectorType"
        case ratedOutputkW       = "RatedOutputkW"
        case ratedOutputVoltage  = "RatedOutputVoltage"
        case ratedOutputCurrent  = "RatedOutputCurrent"
        case chargeMethod        = "ChargeMethod"
        case chargeMode          = "ChargeMode"
        case chargePointStatus   = "ChargePointStatus"
        case tetheredCable       = "TetheredCable"
        case information         = "Information"
        case validated           = "Validated"
    }
}

enum ChargeStatus: String, Decodable {
    case inService     = "In service"
    case outOfService  = "Out of service"
}

enum TetheredCable: String, Decodable {
    case tethered     = "1"
    case notTethered  = "0"
}

enum ChargeMethod: String, Decodable, CaseIterable {
    case dc             = "DC"
    case singlePhaseAc  = "Single Phase AC"
    case threePhaseAc   = "Three Phase AC"
}

enum ConnectorType: String, Decodable, CaseIterable {
    case threePinTypeG  = "3-pin Type G (BS1363)"
    case chAdeMo        = "JEVS G105 (CHAdeMO) DC"
    case type1          = "Type 1 SAEJ1772 (IEC 62196)"
    case type2Mennekes  = "Type 2 Mennekes (IEC62196)"
    case type3Scame     = "Type 3 Scame (IEC62196)"
    case ccsType2Combo  = "CCS Type 2 Combo (IEC62196)"
    case type2Tesla     = "Type 2 Tesla (IEC62196) DC"
    case commando2PE    = "Commando 2P+E (IEC60309)"
    case commando3PNE   = "Commando 3P+N+E (IEC60309)"
}

// MARK: - ConnectorGraphic

struct ConnectorGraphic: Identifiable {
    var id = UUID()
    var name: String
    var count: Int
}
