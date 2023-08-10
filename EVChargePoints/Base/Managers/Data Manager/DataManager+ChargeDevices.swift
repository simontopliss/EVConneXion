//
//  DataManager+ChargeDevices.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 10/08/2023.
//

import Foundation

extension DataManager {

    struct NameAndPostcode: Hashable {
        let chargeDeviceName: String
        let postcode: String
    }

    func sortAndRemoveDuplicateDevices(chargeDevices: [ChargeDevice]) -> [ChargeDevice] {
        let deviceNamesAndPostcodes = getDeviceNamesAndPostcodes(chargeDevices: chargeDevices)
        let duplicates = deviceNamesAndPostcodes.duplicates()
        let duplicateChargeDevices = combineConnectorsFromDuplicateDevices(duplicates: duplicates)
        let newChargeDevices = removeDuplicatesFromChargeDevices(duplicates: duplicates, chargeDevices: chargeDevices)
        let finalChargeDevices = (newChargeDevices + duplicateChargeDevices).sorted(
            by: { $0.deviceMapItem.distanceFromUser < $1.deviceMapItem.distanceFromUser }
        )
        return finalChargeDevices
    }

    func getDeviceNamesAndPostcodes(chargeDevices: [ChargeDevice]) -> [NameAndPostcode] {
        let namesAndPostcodes = chargeDevices.compactMap {
            NameAndPostcode(
                chargeDeviceName: $0.chargeDeviceName,
                postcode: $0.chargeDeviceLocation.address.postcode
            )
        }

        return namesAndPostcodes
    }

    func combineConnectorsFromDuplicateDevices(duplicates: [NameAndPostcode]) -> [ChargeDevice] {
        var duplicateChargeDevices: [ChargeDevice] = []
        for duplicate in duplicates {
            let chargeDeviceName = duplicate.chargeDeviceName
            let postcode = duplicate.postcode
            let filteredChargeDevices = chargeDevices.filter {
                $0.chargeDeviceName == chargeDeviceName &&
                $0.chargeDeviceLocation.address.postcode == postcode
            }
            let connectors = filteredChargeDevices.flatMap { $0.connector }
            var firstDevice = filteredChargeDevices.first!
            firstDevice.connector = connectors
            duplicateChargeDevices.append(firstDevice)
        }

        return duplicateChargeDevices
    }

    func removeDuplicatesFromChargeDevices(duplicates: [NameAndPostcode], chargeDevices: [ChargeDevice]) -> [ChargeDevice] {
        var newChargeDevices: [ChargeDevice] = []
        for chargeDevice in chargeDevices {
            let nameAndPostcode = NameAndPostcode(
                chargeDeviceName: chargeDevice.chargeDeviceName,
                postcode: chargeDevice.chargeDeviceLocation.address.postcode
            )
            if !duplicates.contains(nameAndPostcode) {
                newChargeDevices.append(chargeDevice)
            }
        }

        return newChargeDevices
    }
}
