//
//  NetworkManager.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//
//   let chargePointData = try? JSONDecoder().decode(ChargePointData.self, from: jsonData)

import Foundation

// MARK: - ChargePointData
public struct ChargePointData: Decodable {
    let scheme: Scheme
    let chargeDevices: [ChargeDevice]

    enum CodingKeys: String, CodingKey {
        case scheme = "Scheme"
        case chargeDevices = "ChargeDevice"
    }
}

// MARK: - ChargeDevice
public struct ChargeDevice: Decodable {
    let chargeDeviceId: String
    let chargeDeviceRef: String
    let chargeDeviceName: String
    let chargeDeviceText: String?
    let chargeDeviceLocation: ChargeDeviceLocation
    let chargeDeviceModel: String?
    let publishStatusId: String
    let dateCreated: String
    let dateUpdated: String
    let attribution: String
    let dateDeleted: String
    let connector: [Connector]
    let deviceOwner: DeviceOwner
    let deviceController: DeviceController
    let deviceAccess: DeviceAccess
    let deviceNetworks: String
    let chargeDeviceStatus: ChargeStatus
    let publishStatus: String
    let deviceValidated: String
    let recordModerated: RecordModerated
    let recordLastUpdated: String?
    let recordLastUpdatedBy: String?
    let paymentRequiredFlag: Bool
    let paymentDetails: String?
    let subscriptionRequiredFlag: Bool
    let subscriptionDetails: String?
    let parkingFeesFlag: Bool
    let parkingFeesDetails: String?
    let parkingFeesUrl: String?
    let accessRestrictionFlag: Bool
    let accessRestrictionDetails: String?
    let physicalRestrictionFlag: Bool
    let physicalRestrictionText: String?
    let onStreetFlag: Bool
    let locationType: String
    let bearing: String?
    let accessible24Hours: Bool

    enum CodingKeys: String, CodingKey {
        case chargeDeviceId = "ChargeDeviceId"
        case chargeDeviceRef = "ChargeDeviceRef"
        case chargeDeviceName = "ChargeDeviceName"
        case chargeDeviceText = "ChargeDeviceText"
        case chargeDeviceLocation = "ChargeDeviceLocation"
        case chargeDeviceModel = "ChargeDeviceModel"
        case publishStatusId = "PublishStatusID"
        case dateCreated = "DateCreated"
        case dateUpdated = "DateUpdated"
        case attribution = "Attribution"
        case dateDeleted = "DateDeleted"
        case connector = "Connector"
        case deviceOwner = "DeviceOwner"
        case deviceController = "DeviceController"
        case deviceAccess = "DeviceAccess"
        case deviceNetworks = "DeviceNetworks"
        case chargeDeviceStatus = "ChargeDeviceStatus"
        case publishStatus = "PublishStatus"
        case deviceValidated = "DeviceValidated"
        case recordModerated = "RecordModerated"
        case recordLastUpdated = "RecordLastUpdated"
        case recordLastUpdatedBy = "RecordLastUpdatedBy"
        case paymentRequiredFlag = "PaymentRequiredFlag"
        case paymentDetails = "PaymentDetails"
        case subscriptionRequiredFlag = "SubscriptionRequiredFlag"
        case subscriptionDetails = "SubscriptionDetails"
        case parkingFeesFlag = "ParkingFeesFlag"
        case parkingFeesDetails = "ParkingFeesDetails"
        case parkingFeesUrl = "ParkingFeesUrl"
        case accessRestrictionFlag = "AccessRestrictionFlag"
        case accessRestrictionDetails = "AccessRestrictionDetails"
        case physicalRestrictionFlag = "PhysicalRestrictionFlag"
        case physicalRestrictionText = "PhysicalRestrictionText"
        case onStreetFlag = "OnStreetFlag"
        case locationType = "LocationType"
        case bearing = "Bearing"
        case accessible24Hours = "Accessible24Hours"
    }
}

// MARK: - ChargeDeviceLocation
struct ChargeDeviceLocation: Decodable {
    let latitude: String
    let longitude: String
    let address: [String: String?]
    let locationShortDescription: String?
    let locationLongDescription: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
        case address = "Address"
        case locationShortDescription = "LocationShortDescription"
        case locationLongDescription = "LocationLongDescription"
    }
}

enum ChargeStatus: String, Decodable {
    case inService = "In service"
    case outOfService = "Out of service"
}

// MARK: - Connector
struct Connector: Decodable {
    let connectorId: String
    let connectorType: ConnectorType
    let ratedOutputkW: String
    let ratedOutputVoltage: String
    let ratedOutputCurrent: String
    let chargeMethod: ChargeMethod
    let chargeMode: String
    let chargePointStatus: ChargeStatus
    let tetheredCable: String
    let information: String?
    let validated: String

    enum CodingKeys: String, CodingKey {
        case connectorId = "ConnectorId"
        case connectorType = "ConnectorType"
        case ratedOutputkW = "RatedOutputkW"
        case ratedOutputVoltage = "RatedOutputVoltage"
        case ratedOutputCurrent = "RatedOutputCurrent"
        case chargeMethod = "ChargeMethod"
        case chargeMode = "ChargeMode"
        case chargePointStatus = "ChargePointStatus"
        case tetheredCable = "TetheredCable"
        case information = "Information"
        case validated = "Validated"
    }
}

enum ChargeMethod: String, Decodable, CaseIterable {
    case dc = "DC"
    case singlePhaseAc = "Single Phase AC"
    case threePhaseAc = "Three Phase AC"
}

enum ConnectorType: String, Decodable, CaseIterable {
    case threePinTypeG = "3-pin Type G (BS1363)"
    case chAdeMo = "JEVS G105 (CHAdeMO) DC"
    case type1 = "Type 1 SAEJ1772 (IEC 62196)"
    case type2Mennekes = "Type 2 Mennekes (IEC62196)"
    case type3Scame = "Type 3 Scame (IEC62196)"
    case ccsType2Combo = "CCS Type 2 Combo (IEC62196)"
    case type2Tesla = "Type 2 Tesla (IEC62196) DC"
    case commando2PE = "Commando 2P+E (IEC60309)"
    case commando3PNE = "Commando 3P+N+E (IEC60309)"
}

enum ConnectorTypeID: Int {
    case threePinTypeG = 3
    case chAdeMo = 4
    case type1 = 5
    case type2Mennekes = 6
    case type3Scame = 7
    case ccsType2Combo = 15
    case type2Tesla = 16
    case commando2PE = 17
    case commando3PNE = 18
}

// MARK: - DeviceAccess
struct DeviceAccess: Decodable {
    let open24Hours: Bool

    enum CodingKeys: String, CodingKey {
        case open24Hours = "Open24Hours"
    }

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.open24Hours = try container.decode(Bool.self, forKey: .open24Hours)
        } catch {
            self.open24Hours = false
        }
    }
}

// MARK: - DeviceController
struct DeviceController: Decodable {
    let organisationName: String
    let schemeCode: String
    let website: String
    let telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName = "OrganisationName"
        case schemeCode = "SchemeCode"
        case website = "Website"
        case telephoneNo = "TelephoneNo"
    }
}

// MARK: - DeviceOwner
struct DeviceOwner: Decodable {
    let organisationName: String
    let schemeCode: String
    let website: String
    let telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName = "OrganisationName"
        case schemeCode = "SchemeCode"
        case website = "Website"
        case telephoneNo = "TelephoneNo"
    }
}

enum RecordModerated: String, Decodable {
    case no = "N"
    case yes = "Y"
}

// MARK: - Scheme
struct Scheme: Decodable {
    let schemeCode: String
    let schemeData: SchemeData

    enum CodingKeys: String, CodingKey {
        case schemeCode = "SchemeCode"
        case schemeData = "SchemeData"
    }
}

// MARK: - SchemeData
struct SchemeData: Decodable {
    let organisationName: String
    let website: String
    let telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName = "OrganisationName"
        case website = "Website"
        case telephoneNo = "TelephoneNo"
    }
}
