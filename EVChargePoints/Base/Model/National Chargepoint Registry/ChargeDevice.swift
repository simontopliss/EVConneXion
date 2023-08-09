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
    var deviceMapItem: DeviceMapItem // Map Item
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
    var deviceNetworks: [String] = []
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
        case chargeDeviceID            = "ChargeDeviceId"
        case chargeDeviceRef           = "ChargeDeviceRef"
        case chargeDeviceName          = "ChargeDeviceName"
        case chargeDeviceText          = "ChargeDeviceText"
        case chargeDeviceLocation      = "ChargeDeviceLocation"
        case chargeDeviceModel         = "ChargeDeviceModel"
        case publishStatusId           = "PublishStatusID"
        case dateCreated               = "DateCreated"
        case dateUpdated               = "DateUpdated"
        case attribution               = "Attribution"
        case dateDeleted               = "DateDeleted"
        case connector                 = "Connector"
        case deviceOwner               = "DeviceOwner"
        case deviceController          = "DeviceController"
        case deviceAccess              = "DeviceAccess"
        case deviceNetworks            = "DeviceNetworks"
        case chargeDeviceStatus        = "ChargeDeviceStatus"
        case publishStatus             = "PublishStatus"
        case deviceValidated           = "DeviceValidated"
        case recordModerated           = "RecordModerated"
        case recordLastUpdated         = "RecordLastUpdated"
        case recordLastUpdatedBy       = "RecordLastUpdatedBy"
        case paymentRequiredFlag       = "PaymentRequiredFlag"
        case paymentDetails            = "PaymentDetails"
        case subscriptionRequiredFlag  = "SubscriptionRequiredFlag"
        case subscriptionDetails       = "SubscriptionDetails"
        case parkingFeesFlag           = "ParkingFeesFlag"
        case parkingFeesDetails        = "ParkingFeesDetails"
        case parkingFeesUrl            = "ParkingFeesUrl"
        case accessRestrictionFlag     = "AccessRestrictionFlag"
        case accessRestrictionDetails  = "AccessRestrictionDetails"
        case physicalRestrictionFlag   = "PhysicalRestrictionFlag"
        case physicalRestrictionText   = "PhysicalRestrictionText"
        case onStreetFlag              = "OnStreetFlag"
        case locationType              = "LocationType"
        case bearing                   = "Bearing"
        case accessible24Hours         = "Accessible24Hours"
    }
}

extension ChargeDevice {
    init(from decoder: Decoder) throws {
        let container         = try decoder.container(keyedBy: CodingKeys.self)
        chargeDeviceID        = try container.decode(String.self, forKey: .chargeDeviceID)
        chargeDeviceRef       = try container.decode(String.self, forKey: .chargeDeviceRef)
        chargeDeviceName      = try container.decode(String.self, forKey: .chargeDeviceName)
        chargeDeviceText      = try container.decodeIfPresent(String.self, forKey: .chargeDeviceText)
        chargeDeviceLocation  = try container.decode(ChargeDeviceLocation.self, forKey: .chargeDeviceLocation)
        chargeDeviceModel     = try container.decodeIfPresent(String.self, forKey: .chargeDeviceModel)
        publishStatusId       = try container.decode(String.self, forKey: .publishStatusId)
        dateCreated           = try container.decode(String.self, forKey: .dateCreated)
        dateUpdated           = try container.decode(String.self, forKey: .dateUpdated)

        // Remove duplicate Attributions that have slightly different spellings
        let attribution = try container.decode(String.self, forKey: .attribution)
        if attribution == "BP-Pulse (POLAR)" {
            self.attribution = "BP Pulse"
        } else if attribution == "Shell Recharge Solutions" {
            self.attribution = "Shell Recharge"
        } else if attribution == "SSE Energy Solutions" {
            self.attribution = "SSE"
        } else {
            self.attribution = attribution
        }

        dateDeleted       = try container.decode(String.self, forKey: .dateDeleted)
        connector         = try container.decode([Connector].self, forKey: .connector)
        deviceOwner       = try container.decode(DeviceOwner.self, forKey: .deviceOwner)
        deviceController  = try container.decode(DeviceController.self, forKey: .deviceController)
        deviceAccess      = try container.decodeIfPresent(DeviceAccess.self, forKey: .deviceAccess)

        // Remove duplicate DeviceNetworks that have slightly different spellings and split on the comma
        let deviceNetworks = try container.decode(String.self, forKey: .deviceNetworks)
        var networks: [String] = []
        if deviceNetworks.contains(",") {
            networks = deviceNetworks.components(separatedBy: ",")
        } else {
            networks = [deviceNetworks]
        }
        for network in networks {
            if network == "BP-Pulse (POLAR)" {
                self.deviceNetworks.append("BP Pulse")
            } else if network == "Shell Recharge Solutions" {
                self.deviceNetworks.append("Shell Recharge")
            } else if network == "SSE Energy Solutions" {
                self.deviceNetworks.append("SSE")
            } else {
                self.deviceNetworks.append(network)
            }
        }

        chargeDeviceStatus        = try container.decode(ChargeStatus.self, forKey: .chargeDeviceStatus)
        publishStatus             = try container.decode(String.self, forKey: .publishStatus)
        deviceValidated           = try container.decode(String.self, forKey: .deviceValidated)
        recordModerated           = try container.decode(RecordModerated.self, forKey: .recordModerated)
        recordLastUpdated         = try container.decodeIfPresent(String.self, forKey: .recordLastUpdated)
        recordLastUpdatedBy       = try container.decodeIfPresent(String.self, forKey: .recordLastUpdatedBy)
        paymentRequiredFlag       = try container.decode(Bool.self, forKey: .paymentRequiredFlag)
        paymentDetails            = try container.decodeIfPresent(String.self, forKey: .paymentDetails)
        subscriptionRequiredFlag  = try container.decode(Bool.self, forKey: .subscriptionRequiredFlag)
        subscriptionDetails       = try container.decodeIfPresent(String.self, forKey: .subscriptionDetails)
        parkingFeesFlag           = try container.decode(Bool.self, forKey: .parkingFeesFlag)
        parkingFeesDetails        = try container.decodeIfPresent(String.self, forKey: .parkingFeesDetails)
        parkingFeesUrl            = try container.decodeIfPresent(String.self, forKey: .parkingFeesUrl)
        accessRestrictionFlag     = try container.decode(Bool.self, forKey: .accessRestrictionFlag)
        accessRestrictionDetails  = try container.decodeIfPresent(String.self, forKey: .accessRestrictionDetails)
        physicalRestrictionFlag   = try container.decode(Bool.self, forKey: .physicalRestrictionFlag)
        physicalRestrictionText   = try container.decodeIfPresent(String.self, forKey: .physicalRestrictionText)
        onStreetFlag              = try container.decode(Bool.self, forKey: .onStreetFlag)
        locationType              = try container.decode(LocationType.self, forKey: .locationType)
        bearing                   = try container.decodeIfPresent(String.self, forKey: .bearing)
        accessible24Hours         = try container.decode(Bool.self, forKey: .accessible24Hours)

        deviceMapItem = DeviceMapItem(
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

