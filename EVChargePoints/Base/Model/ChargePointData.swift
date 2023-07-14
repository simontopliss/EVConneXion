//
//  NetworkManager.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//
//   let chargePointData = try? JSONDecoder().decode(ChargePointData.self, from: jsonData)

import Foundation

@propertyWrapper struct Trimmed {
    private var text: String
    var wrappedValue: String {
        get {
            text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            text = newValue
        }
    }
    init(wrappedValue: String) {
        text = wrappedValue
    }
}

struct ChargePointData: Decodable {

    let scheme: Scheme
    var chargeDevices: [ChargeDevice]

    enum CodingKeys: String, CodingKey {
        case scheme = "Scheme"
        case chargeDevices = "ChargeDevice"
    }
}

// MARK: - ChargeDevice

struct ChargeDevice: Decodable, Identifiable {
    var id = UUID()

    var chargeDeviceID: String
    var chargeDeviceRef: String
    var chargeDeviceName: String
    var chargeDeviceText: String?
    var chargeDeviceLocation: ChargeDeviceLocation
    var chargeDeviceModel: String?
    var publishStatusId: String
    var dateCreated: String
    var dateUpdated: String
    var attribution: String
    var dateDeleted: String
    var connector: [Connector]
    var deviceOwner: DeviceOwner
    var deviceController: DeviceController
    var deviceAccess: DeviceAccess?
    var deviceNetworks: String
    var chargeDeviceStatus: ChargeStatus
    var publishStatus: String
    var deviceValidated: String
    var recordModerated: RecordModerated
    var recordLastUpdated: String?
    var recordLastUpdatedBy: String?
    var paymentRequiredFlag: Bool
    var paymentDetails: String?
    var subscriptionRequiredFlag: Bool
    var subscriptionDetails: String?
    var parkingFeesFlag: Bool
    var parkingFeesDetails: String?
    var parkingFeesUrl: String?
    var accessRestrictionFlag: Bool
    var accessRestrictionDetails: String?
    var physicalRestrictionFlag: Bool
    var physicalRestrictionText: String?
    var onStreetFlag: Bool
    var locationType: LocationType
    var bearing: String?
    var accessible24Hours: Bool

    enum CodingKeys: String, CodingKey {
        case chargeDeviceID = "ChargeDeviceId"
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

enum LocationType: String, Decodable, CaseIterable {
    case dealershipForecourt = "Dealership forecourt"
    case educationalEstablishment = "Educational establishment"
    case hotelAccommodation = "Hotel / Accommodation"
    case leisureCentre = "Leisure centre"
    case nhsProperty = "NHS property"
    case onStreet = "On-street"
    case other = "Other"
    case parkRideSite = "Park & Ride site"
    case privateHome = "Private home"
    case publicCarPark = "Public car park"
    case publicEstate = "Public estate"
    case retailCarPark = "Retail car park"
    case serviceStation = "Service station"
    case workplaceCarPark = "Workplace car park"
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

// MARK: - ChargeDeviceLocation

struct ChargeDeviceLocation: Decodable {
    var latitude: String
    var longitude: String
    var address: [String: String?]
    var locationShortDescription: String?
    var locationLongDescription: String?

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

enum TetheredCable: String, Decodable {
    case tethered = "1"
    case notTethered = "0"
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
    var open24Hours: Bool = false
    var regularOpenings: [RegularOpening]?

    enum CodingKeys: String, CodingKey {
        case open24Hours = "Open24Hours"
        case regularOpenings = "RegularOpenings"
    }
}

extension DeviceAccess {
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            open24Hours = try container.decode(Bool.self, forKey: .open24Hours)
        } catch {
            open24Hours = false
        }

        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            regularOpenings = try container.decodeIfPresent([RegularOpening].self, forKey: .regularOpenings)
        } catch {
            // print(error)
            regularOpenings = nil
        }
    }
}

// MARK: - RegularOpening

struct RegularOpening: Codable {
    var days: String?
    var hours: Hours?
    var allDays = false

    enum CodingKeys: String, CodingKey {
        case days = "Days"
        case hours = "Hours"
        case allDays
    }
}

extension RegularOpening {
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            days = try container.decode(String.self, forKey: .days)
        } catch {
            days = nil
            allDays = true
        }

        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            hours = try container.decode(Hours.self, forKey: .hours)
        } catch {
            hours = nil
        }
    }
}

// MARK: - Hours

struct Hours: Codable {
    var from: String
    var to: String

    enum CodingKeys: String, CodingKey {
        case from = "From"
        case to = "To"
    }
}

// MARK: - DeviceController

struct DeviceController: Decodable {
    var organisationName: String
    var schemeCode: String
    var website: String
    var telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName = "OrganisationName"
        case schemeCode = "SchemeCode"
        case website = "Website"
        case telephoneNo = "TelephoneNo"
    }
}

// MARK: - DeviceOwner

struct DeviceOwner: Decodable {
    var organisationName: String
    var schemeCode: String
    var website: String
    var telephoneNo: String

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
        case organisationName = "OrganisationName"
        case website = "Website"
        case telephoneNo = "TelephoneNo"
    }
}

