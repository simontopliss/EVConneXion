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
    var address: Address
    var locationShortDescription: String?
    var locationLongDescription: String?

    var singleLineAddress: String
    var fullAddress: String

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
        let address = try container.decode([String : String?].self, forKey: .address)
        self.locationShortDescription = try container.decodeIfPresent(String.self, forKey: .locationShortDescription)
        self.locationLongDescription = try container.decodeIfPresent(String.self, forKey: .locationLongDescription)

        // Create the Address struct
        self.address = Address(address: address)
        self.singleLineAddress = self.address.singleLineAddress
        self.fullAddress = self.address.fullAddress
    }
}

struct Address {

    var subBuildingName = ""
    var buildingName = ""
    var buildingNumber = ""
    var thoroughfare = ""
    var street = ""
    var doubleDependantLocality = ""
    var dependantLocality = ""
    var postTown = ""
    var county = ""
    var postcode = ""
    var country = ""

    var addressArray: [String] {
        var arr: [String] = []
        if !self.subBuildingName.isEmpty { arr.append(self.subBuildingName) }
        if !self.buildingName.isEmpty { arr.append(self.buildingName) }
        if !self.buildingNumber.isEmpty { arr.append(self.buildingNumber) }
        if !self.thoroughfare.isEmpty { arr.append(self.thoroughfare) }
        if !self.street.isEmpty { arr.append(self.street) }
        if !self.doubleDependantLocality.isEmpty { arr.append(self.doubleDependantLocality) }
        if !self.dependantLocality.isEmpty { arr.append(self.dependantLocality) }
        if !self.postTown.isEmpty { arr.append(self.postTown) }
        if !self.county.isEmpty { arr.append(self.county) }
        if !self.postcode.isEmpty { arr.append(self.postcode) }
        return arr
    }

    var singleLineAddress: String {
        addressArray.joined(separator: ", ")
    }

    var fullAddress: String {
        addressArray.joined(separator: "\n")
    }

    init(address: [String: String?]) {
        parseAddress(address: address)
    }
}

extension Address {
    mutating func parseAddress(address: [String: String?]) {
        for (k,v) in address {
            // print("\(k) = \(v)")
            if k == "SubBuildingName" {
                if let subBuildingName = v {
                    self.subBuildingName = subBuildingName.trim()
                }
            } else if k == "BuildingName" {
                if let buildingName = v {
                    self.buildingName = buildingName.trim()
                }
            } else if k == "BuildingNumber" {
                if let buildingNumber = v {
                    self.buildingNumber = buildingNumber.trim()
                    if self.buildingNumber.hasPrefix(", ") {
                        self.buildingNumber.removeFirst(2)
                    }
                }
            } else if k == "Thoroughfare" {
                if let thoroughfare = v {
                    self.thoroughfare = thoroughfare.trim()
                }
            } else if k == "Street" {
                if let street = v {
                    self.street = street.trim()
                    if self.street.count < 2 {
                        self.street = ""
                    }
                }
            } else if k == "DoubleDependantLocality" {
                if let doubleDependantLocality = v {
                    self.doubleDependantLocality = doubleDependantLocality.trim()
                }
            } else if k == "DependantLocality" {
                if let dependantLocality = v {
                    self.dependantLocality = dependantLocality.trim()
                }
            } else if k == "PostTown" {
                if let postTown = v {
                    self.postTown = postTown.trim()
                }
            } else if k == "County" {
                if let county = v {
                    self.county = county.trim()
                    if self.county.count < 2 {
                        self.county = "" // Fix some weird Counties are "0" or "4"
                    } else if self.county.hasPrefix("`") {
                        self.county.removeFirst() // Fixes one entry with "`West Midlands"
                    }
                }
            } else if k == "PostCode" {
                if let postcode = v {
                    self.postcode = postcode.trim()
                }
            } else if k == "Country" {
                if let country = v {
                    self.country = country.trim()
                }
            }
        }
    }
}

