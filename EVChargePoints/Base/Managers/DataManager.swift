import Foundation
import SwiftUI

final class DataManager: ObservableObject {

    @Published var accessData: [AccessData] = []
    @Published var chargerData: ChargerData = .init()
    @Published var locationData: [LocationData] = []
    @Published var paymentData: [PaymentData] = []
    @Published var filteredDevices: [ChargeDevice] = []

    init() {
        /// Load JSON files
        loadAccessData()
        loadLocationData()
        loadPaymentData()
    }

    func loadAccessData() {
        accessData = try! StaticJSONMapper.decode(
            file: "AccessData",
            type: [AccessData].self
        )
    }

    func loadLocationData() {
        locationData = try! StaticJSONMapper.decode(
            file: "LocationData",
            type: [LocationData].self
        )
    }

    func loadPaymentData() {
        paymentData = try! StaticJSONMapper.decode(
            file: "PaymentData",
            type: [PaymentData].self
        )
    }

    func applyFilters(chargeDevices: [ChargeDevice], connectorData: [ConnectorData], networkData: [NetworkData]) {
        var filteredDevices: [ChargeDevice] = []

        filteredDevices.append(contentsOf: filterDevicesByAccess(chargeDevices: chargeDevices))
        filteredDevices.append(contentsOf: filterDevicesByLocation(chargeDevices: chargeDevices))
        filteredDevices.append(contentsOf: filterDevicesByConnector(chargeDevices: chargeDevices, connectorData: connectorData))
        filteredDevices.append(contentsOf: filterDevicesByPayment(chargeDevices: chargeDevices))
        filteredDevices.append(contentsOf: filterDevicesByChargerType(chargeDevices: chargeDevices))
        filteredDevices.append(contentsOf: filterDevicesByNetwork(chargeDevices: chargeDevices, networkData: networkData))

        filteredDevices = Array(Set(filteredDevices))

        self.filteredDevices.sort(by: { $0.deviceMapItem.distanceFromUser < $1.deviceMapItem.distanceFromUser })
    }

    func filterDevicesByAccess(chargeDevices: [ChargeDevice]) -> [ChargeDevice] {
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

    func filterDevicesByChargerType(chargeDevices: [ChargeDevice]) -> [ChargeDevice] {
        var filterConnectorDevices: [ChargeDevice] = []
        let slowCharge = 3.0...5.0
        let fastCharge = 7.0...36.0
        // let rapidCharge = 43.0...350

        for chargeDevice in chargeDevices {
            if filterConnectorDevices.contains(chargeDevice) == false {
                let connectors = chargeDevice.connector

                for connector in connectors {
                    if chargerData.selectedSpeed == "Slow" && slowCharge ~= connector.ratedOutputkW {
                        filterConnectorDevices.append(chargeDevice)
                    } else if chargerData.selectedSpeed == "Fast" && fastCharge ~= connector.ratedOutputkW {
                        filterConnectorDevices.append(chargeDevice)
                    } else if chargerData.selectedSpeed == "Rapid+" && connector.ratedOutputkW > 36.0 {
                        filterConnectorDevices.append(chargeDevice)
                    }

                    if chargerData.selectedMethod.rawValue == "Single Phase AC" && connector.chargeMethod == .singlePhaseAc {
                        filterConnectorDevices.append(chargeDevice)
                    } else if chargerData.selectedMethod.rawValue == "Three Phase AC" && connector.chargeMethod == .threePhaseAc {
                        filterConnectorDevices.append(chargeDevice)
                    } else if chargerData.selectedMethod.rawValue == "DC" && connector.chargeMethod == .dc {
                        filterConnectorDevices.append(chargeDevice)
                    }

                    if chargerData.tetheredCable && connector.tetheredCable == true {
                        filterConnectorDevices.append(chargeDevice)
                    }
                }
            }
        }
        return filterConnectorDevices
    }

    func filterDevicesByConnector(chargeDevices: [ChargeDevice], connectorData: [ConnectorData]) -> [ChargeDevice] {
        let filteredConnectorTypes: [String] = connectorData.filter { $0.setting == true }.map { $0.dataName }

        let filteredConnectorDevices = chargeDevices.filter { chargeDevice in
            chargeDevice.connector.contains(where: { connector in
                filteredConnectorTypes.contains(connector.connectorType.rawValue)
            })
        }
        return filteredConnectorDevices
    }

    func filterDevicesByLocation(chargeDevices: [ChargeDevice]) -> [ChargeDevice] {
        let filteredLocationTypes: [String] = locationData.filter { $0.setting == true }.map { $0.dataName }

        let filteredLocationDevices = chargeDevices.filter { chargeDevice in
            filteredLocationTypes.contains(chargeDevice.locationType.rawValue)
        }
        return filteredLocationDevices
    }

    func filterDevicesByNetwork(chargeDevices: [ChargeDevice], networkData: [NetworkData]) -> [ChargeDevice] {
        let networkFilters: [String] = networkData.filter { $0.setting == true }.map { $0.network }

        let filterNetworkDevices = chargeDevices.filter { chargeDevice in
            chargeDevice.deviceNetworks.contains(where: { networkDevice in
                networkFilters.contains(networkDevice)
            })
        }
        return filterNetworkDevices
    }

    func filterDevicesByPayment(chargeDevices: [ChargeDevice]) -> [ChargeDevice] {
        var filteredPaymentDevices: [ChargeDevice] = []
        let filteredPaymentTypes: [PaymentData] = paymentData.filter { $0.setting == true }

        for filteredPaymentType in filteredPaymentTypes {
            if filteredPaymentType.payment == "PaymentRequired" {
                filteredPaymentDevices.append(contentsOf: chargeDevices.filter {
                    $0.paymentRequiredFlag == filteredPaymentType.setting
                })
            } else if filteredPaymentType.payment == "SubscriptionRequired" {
                filteredPaymentDevices.append(contentsOf: chargeDevices.filter {
                    $0.subscriptionRequiredFlag == filteredPaymentType.setting
                })
            }
        }
        return filteredPaymentDevices
    }
}
