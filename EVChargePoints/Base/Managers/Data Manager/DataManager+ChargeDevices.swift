//
//  DataManager+ChargeDevices.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 10/08/2023.
//

import Foundation

extension DataManager {

    struct DeviceNameAndPostcode: Hashable {
        let chargeDeviceName: String
        let postcode: String
    }

    func sortAndRemoveDuplicateDevices(devices: [ChargeDevice]) -> [ChargeDevice] {
        let deviceNamesAndPostcodes = getDeviceNamesAndPostcodes(devices: devices)
        let duplicates = deviceNamesAndPostcodes.duplicates()
        // dump(duplicates)
        let duplicateChargeDevices = combineConnectorsFromDuplicateDevices(
            duplicates: duplicates,
            devices: devices
        )
        let newChargeDevices = removeDuplicatesFromChargeDevices(
            duplicates: duplicates,
            devices: devices
        )
        let finalChargeDevices = (newChargeDevices + duplicateChargeDevices).sorted(
            by: { $0.deviceMapItem.distanceFromUser < $1.deviceMapItem.distanceFromUser }
        )
        return finalChargeDevices
    }

    func getDeviceNamesAndPostcodes(devices: [ChargeDevice]) -> [DeviceNameAndPostcode] {
        let namesAndPostcodes = devices.compactMap {
            DeviceNameAndPostcode(
                chargeDeviceName: $0.chargeDeviceName,
                postcode: $0.chargeDeviceLocation.address.postcode
            )
        }

        return namesAndPostcodes
    }

    func combineConnectorsFromDuplicateDevices(
        duplicates: [DeviceNameAndPostcode],
        devices: [ChargeDevice]
    ) -> [ChargeDevice] {
        var duplicateChargeDevices: [ChargeDevice] = []
        for duplicate in duplicates {
            let chargeDeviceName = duplicate.chargeDeviceName
            let postcode = duplicate.postcode
            let filteredChargeDevices = devices.filter {
                $0.chargeDeviceName == chargeDeviceName &&
                $0.chargeDeviceLocation.address.postcode == postcode
            }
            let connectors = filteredChargeDevices.flatMap { $0.connector }
            var firstDevice = filteredChargeDevices.first
            if firstDevice != nil {
                firstDevice!.connector = connectors
                duplicateChargeDevices.append(firstDevice!)
            } else {
                print(chargeDeviceName)
                print(postcode)
                fatalError("Missing duplicates. This shouldn't happen.")
            }
        }

        return duplicateChargeDevices
    }

    func removeDuplicatesFromChargeDevices(
        duplicates: [DeviceNameAndPostcode],
        devices: [ChargeDevice]
    ) -> [ChargeDevice] {
        var newChargeDevices: [ChargeDevice] = []
        for chargeDevice in devices {
            let nameAndPostcode = DeviceNameAndPostcode(
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
