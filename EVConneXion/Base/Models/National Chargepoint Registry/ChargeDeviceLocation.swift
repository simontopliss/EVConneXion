//
//  ChargeDeviceLocation.swift
//  EVConneXion
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
        case latitude = "Latitude"
        case longitude = "Longitude"
        case address = "Address"
        case locationShortDescription = "LocationShortDescription"
        case locationLongDescription = "LocationLongDescription"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        let address = try container.decode([String: String?].self, forKey: .address)
        locationShortDescription = try container.decodeIfPresent(String.self, forKey: .locationShortDescription)
        locationLongDescription = try container.decodeIfPresent(String.self, forKey: .locationLongDescription)

        // Create the Address struct
        self.address = Address(address: address)
        singleLineAddress = self.address.singleLineAddress
        fullAddress = self.address.fullAddress
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
        if !subBuildingName.isEmpty { arr.append(subBuildingName) }
        if !buildingName.isEmpty { arr.append(buildingName) }
        if !buildingNumber.isEmpty { arr.append(buildingNumber) }
        if !thoroughfare.isEmpty { arr.append(thoroughfare) }
        if !street.isEmpty { arr.append(street) }
        if !doubleDependantLocality.isEmpty { arr.append(doubleDependantLocality) }
        if !dependantLocality.isEmpty { arr.append(dependantLocality) }
        if !postTown.isEmpty { arr.append(postTown) }
        if !county.isEmpty { arr.append(county) }
        if !postcode.isEmpty { arr.append(postcode) }
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
    // swiftlint:disable:next cyclomatic_complexity
    mutating func parseAddress(address: [String: String?]) {
        for (key, value) in address {
            guard let value = value else { continue }
            switch key {
                case "SubBuildingName":
                    subBuildingName = value.trim()
                case "BuildingName":
                    buildingName = value.trim()
                case "BuildingNumber":
                    var buildingNumber = value.trim()
                    if buildingNumber.hasPrefix(", ") { buildingNumber.removeFirst(2) }
                    self.buildingNumber = buildingNumber
                case "Thoroughfare":
                    thoroughfare = value.trim()
                case "Street":
                    var street = value.trim()
                    if street.count < 2 { street = "" }
                    self.street = street
                case "DoubleDependantLocality":
                    doubleDependantLocality = value.trim()
                case "DependantLocality":
                    dependantLocality = value.trim()
                case "PostTown":
                    postTown = value.trim()
                case "County":
                    var county = value.trim()
                    if county.count < 2 {
                        county = ""
                    } else if county.hasPrefix("`") {
                        county.removeFirst()
                    }
                    self.county = county
                case "PostCode":
                    postcode = value.trim()
                case "Country":
                    country = value.trim()
                default:
                    break
            }
        }
    }
}
