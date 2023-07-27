//
//  ChargeDevice.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

// MARK: - ChargeDevice

struct ChargeDevice: Decodable, Identifiable {

    var id = UUID()

    var chargeDeviceID: String
    var chargeDeviceRef: String
    var chargeDeviceName: String
    var chargeDeviceText: String?
    var chargeDeviceLocation: ChargeDeviceLocation
    var deviceMapMarker: DeviceMapMarker // Map Item
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

extension ChargeDevice {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chargeDeviceID = try container.decode(String.self, forKey: .chargeDeviceID)
        self.chargeDeviceRef = try container.decode(String.self, forKey: .chargeDeviceRef)
        self.chargeDeviceName = try container.decode(String.self, forKey: .chargeDeviceName)
        self.chargeDeviceText = try container.decodeIfPresent(String.self, forKey: .chargeDeviceText)
        self.chargeDeviceLocation = try container.decode(ChargeDeviceLocation.self, forKey: .chargeDeviceLocation)
        self.chargeDeviceModel = try container.decodeIfPresent(String.self, forKey: .chargeDeviceModel)
        self.publishStatusId = try container.decode(String.self, forKey: .publishStatusId)
        self.dateCreated = try container.decode(String.self, forKey: .dateCreated)
        self.dateUpdated = try container.decode(String.self, forKey: .dateUpdated)
        self.attribution = try container.decode(String.self, forKey: .attribution)
        self.dateDeleted = try container.decode(String.self, forKey: .dateDeleted)
        self.connector = try container.decode([Connector].self, forKey: .connector)
        self.deviceOwner = try container.decode(DeviceOwner.self, forKey: .deviceOwner)
        self.deviceController = try container.decode(DeviceController.self, forKey: .deviceController)
        self.deviceAccess = try container.decodeIfPresent(DeviceAccess.self, forKey: .deviceAccess)
        self.deviceNetworks = try container.decode(String.self, forKey: .deviceNetworks)
        self.chargeDeviceStatus = try container.decode(ChargeStatus.self, forKey: .chargeDeviceStatus)
        self.publishStatus = try container.decode(String.self, forKey: .publishStatus)
        self.deviceValidated = try container.decode(String.self, forKey: .deviceValidated)
        self.recordModerated = try container.decode(RecordModerated.self, forKey: .recordModerated)
        self.recordLastUpdated = try container.decodeIfPresent(String.self, forKey: .recordLastUpdated)
        self.recordLastUpdatedBy = try container.decodeIfPresent(String.self, forKey: .recordLastUpdatedBy)
        self.paymentRequiredFlag = try container.decode(Bool.self, forKey: .paymentRequiredFlag)
        self.paymentDetails = try container.decodeIfPresent(String.self, forKey: .paymentDetails)
        self.subscriptionRequiredFlag = try container.decode(Bool.self, forKey: .subscriptionRequiredFlag)
        self.subscriptionDetails = try container.decodeIfPresent(String.self, forKey: .subscriptionDetails)
        self.parkingFeesFlag = try container.decode(Bool.self, forKey: .parkingFeesFlag)
        self.parkingFeesDetails = try container.decodeIfPresent(String.self, forKey: .parkingFeesDetails)
        self.parkingFeesUrl = try container.decodeIfPresent(String.self, forKey: .parkingFeesUrl)
        self.accessRestrictionFlag = try container.decode(Bool.self, forKey: .accessRestrictionFlag)
        self.accessRestrictionDetails = try container.decodeIfPresent(String.self, forKey: .accessRestrictionDetails)
        self.physicalRestrictionFlag = try container.decode(Bool.self, forKey: .physicalRestrictionFlag)
        self.physicalRestrictionText = try container.decodeIfPresent(String.self, forKey: .physicalRestrictionText)
        self.onStreetFlag = try container.decode(Bool.self, forKey: .onStreetFlag)
        self.locationType = try container.decode(LocationType.self, forKey: .locationType)
        self.bearing = try container.decodeIfPresent(String.self, forKey: .bearing)
        self.accessible24Hours = try container.decode(Bool.self, forKey: .accessible24Hours)

        self.deviceMapMarker = DeviceMapMarker(
            latitude: Double(chargeDeviceLocation.latitude) ?? 0.0,
            longitude: Double(chargeDeviceLocation.longitude) ?? 0.0
        )
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
