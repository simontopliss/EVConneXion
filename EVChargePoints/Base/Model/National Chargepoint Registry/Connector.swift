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
    var ratedOutputkW: Double
    var ratedOutputVoltage: Int
    var ratedOutputCurrent: Int
    var chargeMethod: ChargeMethod
    var chargeMode: String
    var chargePointStatus: ChargeStatus
    var tetheredCable: Bool
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.connectorId = try container.decode(String.self, forKey: .connectorId)
        self.connectorType = try container.decode(ConnectorType.self, forKey: .connectorType)
        self.ratedOutputkW = Double(try container.decode(String.self, forKey: .ratedOutputkW)) ?? 0.0
        self.ratedOutputVoltage = Int(try container.decode(String.self, forKey: .ratedOutputVoltage)) ?? 0
        self.ratedOutputCurrent = Int(try container.decode(String.self, forKey: .ratedOutputCurrent)) ?? 0
        self.chargeMethod = try container.decode(ChargeMethod.self, forKey: .chargeMethod)
        self.chargeMode = try container.decode(String.self, forKey: .chargeMode)
        self.chargePointStatus = try container.decode(ChargeStatus.self, forKey: .chargePointStatus)
        self.tetheredCable = (try container.decode(String.self, forKey: .tetheredCable)) == "1" ? true : false
        self.information = try container.decodeIfPresent(String.self, forKey: .information)
        self.validated = try container.decode(String.self, forKey: .validated)
    }
}

enum ChargeStatus: String, Decodable {
    case inService     = "In service"
    case outOfService  = "Out of service"
    case planned       = "Planned"
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
