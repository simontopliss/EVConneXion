//
//  ChargeDevice.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation
import Observation

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
        case chargeDeviceID             = "ChargeDeviceId"
        case chargeDeviceRef            = "ChargeDeviceRef"
        case chargeDeviceName           = "ChargeDeviceName"
        case chargeDeviceText           = "ChargeDeviceText"
        case chargeDeviceLocation       = "ChargeDeviceLocation"
        case chargeDeviceModel          = "ChargeDeviceModel"
        case publishStatusId            = "PublishStatusID"
        case dateCreated                = "DateCreated"
        case dateUpdated                = "DateUpdated"
        case attribution                = "Attribution"
        case dateDeleted                = "DateDeleted"
        case connector                  = "Connector"
        case deviceOwner                = "DeviceOwner"
        case deviceController           = "DeviceController"
        case deviceAccess               = "DeviceAccess"
        case deviceNetworks             = "DeviceNetworks"
        case chargeDeviceStatus         = "ChargeDeviceStatus"
        case publishStatus              = "PublishStatus"
        case deviceValidated            = "DeviceValidated"
        case recordModerated            = "RecordModerated"
        case recordLastUpdated          = "RecordLastUpdated"
        case recordLastUpdatedBy        = "RecordLastUpdatedBy"
        case paymentRequiredFlag        = "PaymentRequiredFlag"
        case paymentDetails             = "PaymentDetails"
        case subscriptionRequiredFlag   = "SubscriptionRequiredFlag"
        case subscriptionDetails        = "SubscriptionDetails"
        case parkingFeesFlag            = "ParkingFeesFlag"
        case parkingFeesDetails         = "ParkingFeesDetails"
        case parkingFeesUrl             = "ParkingFeesUrl"
        case accessRestrictionFlag      = "AccessRestrictionFlag"
        case accessRestrictionDetails   = "AccessRestrictionDetails"
        case physicalRestrictionFlag    = "PhysicalRestrictionFlag"
        case physicalRestrictionText    = "PhysicalRestrictionText"
        case onStreetFlag               = "OnStreetFlag"
        case locationType               = "LocationType"
        case bearing                    = "Bearing"
        case accessible24Hours          = "Accessible24Hours"
    }
}

extension ChargeDevice: Hashable {
    static func == (lhs: ChargeDevice, rhs: ChargeDevice) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
}

enum RecordModerated: String, Decodable {
    case no   = "N"
    case yes  = "Y"
}
