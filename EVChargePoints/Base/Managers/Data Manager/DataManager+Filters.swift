//
//  DataManager+Filters.swift
//  EVChargePoints
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

    func applyFilters() {

        var filteredDevices: [ChargeDevice] = []
        filterResultError = false
        filterResultErrorMessage = ""

        let filteredLocationTypes = filterDevicesByLocation()
        if filteredLocationTypes.isEmpty {
            filterResultError = true
            filterResultErrorMessage = "No location types found in this area. Try a wider search of choose a different filter."
            filteredDevices = chargeDevices
        } else {
            filteredDevices += filteredLocationTypes
        }

        let filteredConnectorDevices = filterDevicesByConnector()
        if filteredConnectorDevices.isEmpty {
            filterResultError = true
            filterResultErrorMessage = "No connection types found in this area. Try a wider search of choose a different filter."
            filteredDevices = chargeDevices
        } else {
            filteredDevices += filteredConnectorDevices
        }

        let filteredChargerDevices = filterDevicesByChargerType()
        if filteredChargerDevices.isEmpty {
            filterResultError = true
            filterResultErrorMessage = "No charger types found in this area. Try a wider search of choose a different filter."
            filteredDevices = chargeDevices
        } else {
            filteredDevices += filteredChargerDevices
        }

        let filteredNetworkDevices = filterDevicesByNetwork()
        if filteredNetworkDevices.isEmpty {
            filterResultError = true
            filterResultErrorMessage = "No network types found in this area. Try a wider search of choose a different filter."
            filteredDevices = chargeDevices
        } else {
            filteredDevices += filteredNetworkDevices
        }

        if !filterResultErrorMessage.isEmpty {

            filteredDevices = chargeDevices

        } else {

            let filteredAccessDevices = filterDevicesByAccess()
            if !filteredAccessDevices.isEmpty { filteredDevices += filteredAccessDevices }

            let filteredPaymentDevices = filterDevicesByPayment()
            if !filteredPaymentDevices.isEmpty { filteredDevices += filteredPaymentDevices }

            filteredDevices = filteredDevices.compactMap { $0 }

            filteredDevices.sort(
                by: { $0.deviceMapItem.distanceFromUser < $1.deviceMapItem.distanceFromUser }
            )

            self.filteredDevices = filteredDevices
        }
    }

    func filterDevicesByAccess() -> [ChargeDevice] {

        var filteredAccessDevices: [ChargeDevice] = []
        let filteredAccessTypes: [AccessData] = accessData.filter { $0.setting == true }

        for filteredAccessTypes in filteredAccessTypes {
            if filteredAccessTypes.dataName == "Accessible24Hours" {
                filteredAccessDevices.append(contentsOf: chargeDevices.filter {
                    $0.accessible24Hours == filteredAccessTypes.setting
                })
            } else if filteredAccessTypes.dataName == "AccessRestrictionFlag" {
                filteredAccessDevices.append(contentsOf: chargeDevices.filter {
                    $0.accessRestrictionFlag == filteredAccessTypes.setting
                })
            } else if filteredAccessTypes.dataName == "ParkingFeesFlag" {
                filteredAccessDevices.append(contentsOf: chargeDevices.filter {
                    $0.parkingFeesFlag == filteredAccessTypes.setting
                })
            } else if filteredAccessTypes.dataName == "PhysicalRestrictionFlag" {
                filteredAccessDevices.append(contentsOf: chargeDevices.filter {
                    $0.physicalRestrictionFlag == filteredAccessTypes.setting
                })
            }
        }
        return filteredAccessDevices
    }

    func filterDevicesByChargerType() -> [ChargeDevice] {

        var filteredChargerDevices: [ChargeDevice] = []
        let slowCharge = 3.0...5.0
        let fastCharge = 7.0...36.0
        // let rapidCharge = 43.0...350

        for chargeDevice in chargeDevices {
            if filteredChargerDevices.contains(chargeDevice) == false {
                let connectors = chargeDevice.connector

                for connector in connectors {
                    if chargerData.selectedSpeed == "Slow", slowCharge ~= connector.ratedOutputkW {
                        filteredChargerDevices.append(chargeDevice)
                    } else if chargerData.selectedSpeed == "Fast",
                              fastCharge ~= connector.ratedOutputkW
                    {
                        filteredChargerDevices.append(chargeDevice)
                    } else if chargerData.selectedSpeed == "Rapid+",
                              connector.ratedOutputkW > 36.0
                    {
                        filteredChargerDevices.append(chargeDevice)
                    }

                    if chargerData.selectedMethod.rawValue == "Single Phase AC",
                       connector.chargeMethod == .singlePhaseAc
                    {
                        filteredChargerDevices.append(chargeDevice)
                    } else if chargerData.selectedMethod.rawValue == "Three Phase AC",
                              connector.chargeMethod == .threePhaseAc
                    {
                        filteredChargerDevices.append(chargeDevice)
                    } else if chargerData.selectedMethod.rawValue == "DC",
                              connector.chargeMethod == .dc
                    {
                        filteredChargerDevices.append(chargeDevice)
                    }

                    if chargerData.tetheredCable, connector.tetheredCable == true {
                        filteredChargerDevices.append(chargeDevice)
                    }
                }
            }
        }
        return filteredChargerDevices
    }

    func filterDevicesByConnector() -> [ChargeDevice] {

        let filteredConnectorTypes: [String] = connectorData.filter {
            $0.setting == true
        }.map { $0.connectorType.rawValue }

        let filteredConnectorDevices = chargeDevices.filter { chargeDevice in
            chargeDevice.connector.contains(where: { connector in
                filteredConnectorTypes.contains(connector.connectorType.rawValue)
            })
        }
        return filteredConnectorDevices
    }

    func filterDevicesByLocation() -> [ChargeDevice] {

        let filteredLocationTypes: [String] = locationData.filter {
            $0.setting == true
        }.map { $0.locationType.rawValue
        }

        let filteredLocationDevices = chargeDevices.filter { chargeDevice in
            filteredLocationTypes.contains(chargeDevice.locationType.rawValue)
        }
        return filteredLocationDevices
    }

    func filterDevicesByNetwork() -> [ChargeDevice] {

        let networkFilters: [String] = networkData.filter { $0.setting == true }.map { $0.network }

        let filteredNetworkDevices = chargeDevices.filter { chargeDevice in
            chargeDevice.deviceNetworks.contains(where: { networkDevice in
                networkFilters.contains(networkDevice)
            })
        }
        return filteredNetworkDevices
    }

    func filterDevicesByPayment() -> [ChargeDevice] {

        var filteredPaymentDevices: [ChargeDevice] = []
        let filteredPaymentTypes: [PaymentData] = paymentData.filter { $0.setting == true }

        for filteredPaymentType in filteredPaymentTypes {
            if filteredPaymentType.dataName == "PaymentRequiredFlag" {
                filteredPaymentDevices.append(contentsOf: chargeDevices.filter {
                    $0.paymentRequiredFlag == filteredPaymentType.setting
                })
            } else if filteredPaymentType.dataName == "SubscriptionRequiredFlag" {
                filteredPaymentDevices.append(contentsOf: chargeDevices.filter {
                    $0.subscriptionRequiredFlag == filteredPaymentType.setting
                })
            }
        }
        return filteredPaymentDevices
    }
}
