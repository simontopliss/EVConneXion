//
//  DataManager+Filters.swift
//  EVConneXion
//
//  Created by Simon Topliss on 10/08/2023.
//

import Foundation

extension DataManager {

    enum FilterResult: String {
        case noLocations
        case noConnectors
        case noChargers
        case noNetworks
    }

    // swiftlint:disable:next function_body_length
    func applyFilters() {
        // print("[\(Self.self)]", #function)
        print("chargeDevices count: \(chargeDevices.count)")

        var filteredDevices: [ChargeDevice] = []
        filterResultError = false
        filterResultErrorMessage = ""

        let filteredLocationTypes = filterDevicesByLocation(chargeDevices)
        print("filteredLocationTypes count: \(filteredLocationTypes.count)")
        if filteredLocationTypes.isEmpty {
            // swiftlint:disable:next line_length
            filterResultErrorMessage = "No location types found in this area. Try a wider search of choose a different filter."
            print(filterResultErrorMessage)
            filterResultError = true
            self.filteredDevices = chargeDevices
            return
        } else {
            filteredDevices = filteredLocationTypes
        }

        let filteredConnectorDevices = filterDevicesByConnector(filteredDevices)
        print("filteredConnectorDevices count: \(filteredConnectorDevices.count)")
        if filteredConnectorDevices.isEmpty {
            // swiftlint:disable:next line_length
            filterResultErrorMessage = "No connection types found in this area. Try a wider search of choose a different filter."
            print(filterResultErrorMessage)
            filterResultError = true
            self.filteredDevices = chargeDevices
            return
        } else {
            filteredDevices = filteredConnectorDevices
        }

        let filteredChargerDevices = filterDevicesByChargerType(filteredDevices)
        print("filteredChargerDevices count: \(filteredChargerDevices.count)")
        if filteredChargerDevices.isEmpty {
            // swiftlint:disable:next line_length
            filterResultErrorMessage = "No charger types found in this area. Try a wider search of choose a different filter."
            print(filterResultErrorMessage)
            filterResultError = true
            self.filteredDevices = chargeDevices
            return
        } else {
            filteredDevices = filteredChargerDevices
        }

        let filteredNetworkDevices = filterDevicesByNetwork(filteredDevices)
        print("filteredNetworkDevices count: \(filteredNetworkDevices.count)")
        if filteredNetworkDevices.isEmpty {
            // swiftlint:disable:next line_length
            filterResultErrorMessage = "No network types found in this area. Try a wider search of choose a different filter."
            print(filterResultErrorMessage)
            filterResultError = true
            self.filteredDevices = chargeDevices
            return
        } else {
            filteredDevices = filteredNetworkDevices
        }

        let filteredAccessDevices = filterDevicesByAccess(filteredDevices)
        print("filteredAccessDevices: \(filteredAccessDevices.count)")
        if filteredAccessDevices.isEmpty {
            // swiftlint:disable:next line_length
            filterResultErrorMessage = "No charge devices found with these access filters in this area. Try a wider search of choose a different filter."
            print(filterResultErrorMessage)
            filterResultError = true
            self.filteredDevices = chargeDevices
            return
        } else {
            filteredDevices = filteredAccessDevices
        }

        let filteredPaymentDevices = filterDevicesByPayment(filteredDevices)
        print("filteredPaymentDevices: \(filteredPaymentDevices.count)")
        if filteredPaymentDevices.isEmpty {
            // swiftlint:disable:next line_length
            filterResultErrorMessage = "No charge devices found with these payment filter in this areas. Try a wider search of choose a different filter."
            print(filterResultErrorMessage)
            filterResultError = true
            self.filteredDevices = chargeDevices
            return
        } else {
            filteredDevices = filteredPaymentDevices
        }

        if !filterResultErrorMessage.isEmpty {
            print(filterResultErrorMessage)
            filterResultError = true
            self.filteredDevices = chargeDevices
            return
        }

        print("filteredDevices count after all filtering: \(filteredDevices.count)")

        filteredDevices.sort {
            LocationManager.shared.distanceFromUser(coordinate: $0.deviceMapItem.coordinate)
                < LocationManager.shared.distanceFromUser(coordinate: $1.deviceMapItem.coordinate)
        }

        filteredDevices = sortAndRemoveDuplicateDevices(devices: filteredDevices)
        print("filteredDevices after sortAndRemoveDuplicateDevices: \(filteredDevices.count)")

        // TODO: Increase or remove limit?
        self.filteredDevices = Array(filteredDevices.prefix(500))
        print("filteredDevices count after prefix: \(filteredDevices.count)")

        if let deviceMapItem = filteredDevices.first?.deviceMapItem {
            LocationManager.shared.userLocation(coordinate: deviceMapItem.coordinate)
        }
    }

    private func filterDevicesByAccess(_ filteredDevices: [ChargeDevice]) -> [ChargeDevice] {
        var filteredAccessDevices: [ChargeDevice] = []
        let filteredAccessTypes: [AccessData] = accessData.filter { $0.setting == true }

        if filteredAccessTypes.isEmpty { return filteredDevices }

        let deviceAccessProperties: [String: (ChargeDevice) -> Bool] = [
            "Accessible24Hours": { $0.accessible24Hours },
            "AccessRestrictionFlag": { $0.accessRestrictionFlag },
            "ParkingFeesFlag": { $0.parkingFeesFlag },
            "PhysicalRestrictionFlag": { $0.physicalRestrictionFlag }
        ]

        for accessType in filteredAccessTypes {
            if let filterFunction = deviceAccessProperties[accessType.dataName] {
                filteredAccessDevices.append(
                    contentsOf: filterDevices(using: filterFunction, from: filteredDevices)
                )
            }
        }

        return filteredAccessDevices
    }

    private func filterDevices(
        using filterFunction: (ChargeDevice) -> Bool,
        from devices: [ChargeDevice]
    ) -> [ChargeDevice] {
        return devices.filter(filterFunction)
    }

    private func filterDevicesByChargerType(_ filteredDevices: [ChargeDevice]) -> [ChargeDevice] {
        var filteredChargerDevices: [ChargeDevice] = []

        let speedCharges: [String: ClosedRange<Double>] = [
            "Slow": 3.0...5.0,
            "Fast": 7.0...36.0,
            "Rapid+": 37.0...Double.infinity
        ]

        let methods: [String: ChargeMethod] = [
            "Single Phase AC": .singlePhaseAc,
            "Three Phase AC": .threePhaseAc,
            "DC": .dc
        ]

        for chargeDevice in filteredDevices where !filteredChargerDevices.contains(chargeDevice) {
            let connectors = chargeDevice.connector
            for connector in connectors {
                if let speedRange = speedCharges[chargerData.selectedSpeed],
                    speedRange ~= connector.ratedOutputkW,
                    methods[chargerData.selectedMethod.rawValue] == connector.chargeMethod,
                    chargerData.tetheredCable == connector.tetheredCable {
                    filteredChargerDevices.append(chargeDevice)
                }
            }
        }

        return filteredChargerDevices
    }

    private func filterDevicesByConnector(_ filteredDevices: [ChargeDevice]) -> [ChargeDevice] {

        let filteredConnectorTypes: [String] = connectorData.filter { $0.setting == true }.map {
            $0.connectorType.rawValue
        }

        let filteredConnectorDevices = filteredDevices.filter { chargeDevice in
            chargeDevice.connector.contains { connector in
                filteredConnectorTypes.contains(connector.connectorType.rawValue)
            }
        }

        return filteredConnectorDevices
    }

    private func filterDevicesByLocation(_ filteredDevices: [ChargeDevice]) -> [ChargeDevice] {
        let filteredLocationTypes: [LocationType] = locationData.filter { $0.setting == true }.map { $0.locationType }
        let filteredLocationDevices = chargeDevices.filter { filteredLocationTypes.contains($0.locationType) }

        return filteredLocationDevices
    }

    private func filterDevicesByNetwork(_ filteredDevices: [ChargeDevice]) -> [ChargeDevice] {
        let networkFilters: [String] = networkData.filter { $0.setting == true }.map { $0.network }
        let filteredNetworkDevices = filteredDevices.filter { chargeDevice in
            chargeDevice.deviceNetworks.contains { networkDevice in
                networkFilters.contains(networkDevice)
            }
        }

        return filteredNetworkDevices
    }

    private func filterDevicesByPayment(_ filteredDevices: [ChargeDevice]) -> [ChargeDevice] {
        let filteredPaymentTypes: [PaymentData] = paymentData.filter { $0.setting == true }
        if filteredPaymentTypes.isEmpty { return filteredDevices }

        let devicePaymentProperties: [String: (ChargeDevice) -> Bool] = [
            "PaymentRequiredFlag": { $0.paymentRequiredFlag },
            "SubscriptionRequiredFlag": { $0.subscriptionRequiredFlag }
        ]

        var filteredPaymentDevices: [ChargeDevice] = []

        for paymentType in filteredPaymentTypes {
            if let filterFunction = devicePaymentProperties[paymentType.dataName] {
                filteredPaymentDevices.append(contentsOf: filteredDevices.filter(filterFunction))
            }
        }

        return filteredPaymentDevices
    }
}
