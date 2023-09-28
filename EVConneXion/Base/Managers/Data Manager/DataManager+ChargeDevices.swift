//
//  DataManager+ChargeDevices.swift
//  EVConneXion
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
        let finalChargeDevices = (newChargeDevices + duplicateChargeDevices).sorted {
            LocationManager.shared.distanceFromUser(coordinate: $0.deviceMapItem.coordinate)
                < LocationManager.shared.distanceFromUser(coordinate: $1.deviceMapItem.coordinate)
        }
        return finalChargeDevices
    }

    private func getDeviceNamesAndPostcodes(devices: [ChargeDevice]) -> [DeviceNameAndPostcode] {
        let namesAndPostcodes = devices.compactMap {
            DeviceNameAndPostcode(
                chargeDeviceName: $0.chargeDeviceName,
                postcode: $0.chargeDeviceLocation.address.postcode
            )
        }

        return namesAndPostcodes
    }

    private func combineConnectorsFromDuplicateDevices(
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
                // swiftlint:disable:next force_unwrapping
                firstDevice!.connector = connectors
                // swiftlint:disable:next force_unwrapping
                duplicateChargeDevices.append(firstDevice!)
            } else {
                print(chargeDeviceName)
                print(postcode)
                fatalError("Missing duplicates. This shouldn't happen.")
            }
        }

        return duplicateChargeDevices
    }

    private func removeDuplicatesFromChargeDevices(
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
