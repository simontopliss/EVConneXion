//
//  Address.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 14/07/2023.
//

import Foundation

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

    init(chargeDeviceLocation: ChargeDeviceLocation) {
        parseAddress(chargeDeviceLocation: chargeDeviceLocation)
    }
}

extension Address {
    mutating func parseAddress(chargeDeviceLocation: ChargeDeviceLocation) {
        for (k,v) in chargeDeviceLocation.address {
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
                }
            } else if k == "Thoroughfare" {
                if let thoroughfare = v {
                    self.thoroughfare = thoroughfare.trim()
                }
            } else if k == "Street" {
                if let street = v {
                    self.street = street.trim()
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
