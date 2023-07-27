//
//  ChargeDeviceLocation.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

// MARK: - ChargeDeviceLocation

struct ChargeDeviceLocation: Decodable {

    var latitude: String
    var longitude: String
    var address: [String: String?]
    var locationShortDescription: String?
    var locationLongDescription: String?

    enum CodingKeys: String, CodingKey {
        case latitude                  = "Latitude"
        case longitude                 = "Longitude"
        case address                   = "Address"
        case locationShortDescription  = "LocationShortDescription"
        case locationLongDescription   = "LocationLongDescription"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(String.self, forKey: .latitude)
        self.longitude = try container.decode(String.self, forKey: .longitude)
        self.address = try container.decode([String : String?].self, forKey: .address)
        self.locationShortDescription = try container.decodeIfPresent(String.self, forKey: .locationShortDescription)
        self.locationLongDescription = try container.decodeIfPresent(String.self, forKey: .locationLongDescription)
    }
}
