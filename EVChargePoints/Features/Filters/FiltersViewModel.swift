//
//  FiltersViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation
import SwiftUI

struct Filter: Identifiable {
    var id = UUID()
    var title: String
    var symbol: Image
    var destination: Route
}

final class FiltersViewModel: ObservableObject {

    @Published var accessData: [AccessData] = []
    @Published var chargerData: ChargerData = ChargerData()
    @Published var locationData: [LocationData] = []
    @Published var paymentData: [PaymentData] = []
    @Published var filters: [Filter] = []

    @Published var filteredDevices: [ChargeDevice] = []

    init() {
        /// Load JSON files
        loadAccessData()
        loadLocationData()
        loadPaymentData()

        filters = [
            Filter(
                title: "Access",
                symbol: Symbols.accessSymbol,
                destination: Route.filterAccessTypesView
            ),
            Filter(
                title: "Charger",
                symbol: Symbols.chargerSymbol,
                destination: Route.filterChargerTypesView
            ),
            Filter(
                title: "Connector",
                symbol: Symbols.connectorSymbol,
                destination: Route.filterConnectorTypesView
            ),
            Filter(
                title: "Location",
                symbol: Symbols.locationSymbol,
                destination: Route.filterLocationTypesView
            ),
            Filter(
                title: "Network",
                symbol: Symbols.networkSymbol,
                destination: Route.filterNetworkTypesView
            ),
            Filter(
                title: "Payment",
                symbol: Symbols.paymentSymbol,
                destination: Route.filterPaymentTypesView
            )
        ]
    }

    func loadAccessData() {
        self.accessData = try! StaticJSONMapper.decode(
            file: "AccessData",
            type: [AccessData].self
        )
    }

    func loadLocationData() {
        self.locationData = try! StaticJSONMapper.decode(
            file: "LocationData",
            type: [LocationData].self
        )
    }

    func loadPaymentData() {
        self.paymentData = try! StaticJSONMapper.decode(
            file: "PaymentData",
            type: [PaymentData].self
        )
    }

    func applyFilters(chargeDevices: [ChargeDevice], connectorData: [ConnectorData], networkData: [NetworkData]) {
        filteredDevices = []

        filterDevicesByAccess(chargeDevices: chargeDevices)
        filteredDevicesByLocation(chargeDevices: chargeDevices)
        filterDevicesByConnectorType(chargeDevices: chargeDevices, connectorData: connectorData)
        filterDevicesByPayment(chargeDevices: chargeDevices)
        filterDevicesByChargerType(chargeDevices: chargeDevices)
        filterByNetwork(chargeDevices: chargeDevices, networkData: networkData)
    }

    func filterDevicesByAccess(chargeDevices: [ChargeDevice]) {
        let accessFilters: [AccessData] = accessData.filter { $0.setting == true }
        for accessFilter in accessFilters {
            if accessFilter.access == "Accessible24Hours" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.accessible24Hours == true })
            } else if accessFilter.access == "AccessRestriction" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.accessRestrictionFlag == true })
            } else if accessFilter.access == "ParkingFees" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.parkingFeesFlag == true })
            } else if accessFilter.access == "PhysicalRestriction" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.physicalRestrictionFlag == true })
            }
        }
    }

    func filteredDevicesByLocation(chargeDevices: [ChargeDevice]) {
        let locationFilters: [LocationData] = locationData.filter { $0.setting == true }
        for locationFilter in locationFilters {
            if locationFilter.location == "DealershipForecourt" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .dealershipForecourt })
            } else if locationFilter.location == "EducationalEstablishment" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .educationalEstablishment })
            } else if locationFilter.location == "HotelAccommodation" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .hotelAccommodation })
            } else if locationFilter.location == "LeisureCentre" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .leisureCentre })
            } else if locationFilter.location == "NhsProperty" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .nhsProperty })
            } else if locationFilter.location == "OnStreet" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .onStreet })
            } else if locationFilter.location == "Other" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .other })
            } else if locationFilter.location == "ParkRideSite" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .parkRideSite })
            } else if locationFilter.location == "PrivateHome" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .privateHome })
            } else if locationFilter.location == "PublicCarPark" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .publicCarPark })
            } else if locationFilter.location == "PublicEstate" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .publicEstate })
            } else if locationFilter.location == "RetailCarPark" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .retailCarPark })
            } else if locationFilter.location == "ServiceStation" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .serviceStation })
            } else if locationFilter.location == "WorkplaceCarPark" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.locationType == .workplaceCarPark })
            }
        }
    }

    func filterDevicesByPayment(chargeDevices: [ChargeDevice]) {
        let paymentFilters: [PaymentData] = paymentData.filter { $0.setting == true }
        for paymentFilter in paymentFilters {
            if paymentFilter.payment == "PaymentRequired" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.paymentRequiredFlag == true })
            } else if paymentFilter.payment == "SubscriptionRequired" {
                filteredDevices.append(contentsOf: chargeDevices.filter { $0.subscriptionRequiredFlag == true })
            }
        }
    }

    // TODO: Need to pass connectorData in from ChargePointViewModel
    func filterDevicesByConnectorType(chargeDevices: [ChargeDevice], connectorData: [ConnectorData]) {
        let connectorFilters: [ConnectorData] = connectorData.filter { $0.setting == true }
        for chargeDevice in chargeDevices {
            if filteredDevices.contains(chargeDevice) == false {
                let connectors = chargeDevice.connector
                for connector in connectors {
                    for connectorFilter in connectorFilters {
                        if connectorFilter.connector == "ThreePinTypeG" {
                            if connector.connectorType == .threePinTypeG {
                                filteredDevices.append(chargeDevice)
                            }
                        } else if connectorFilter.connector == "ChAdeMo" {
                            if connector.connectorType == .chAdeMo {
                                filteredDevices.append(chargeDevice)
                            }
                        } else if connectorFilter.connector == "Type1" {
                            if connector.connectorType == .type1 {
                                filteredDevices.append(chargeDevice)
                            }
                        } else if connectorFilter.connector == "Type2Mennekes" {
                            if connector.connectorType == .type2Mennekes {
                                filteredDevices.append(chargeDevice)
                            }
                        } else if connectorFilter.connector == "Type3Scame" {
                            if connector.connectorType == .type3Scame {
                                filteredDevices.append(chargeDevice)
                            }
                        } else if connectorFilter.connector == "CcsType2Combo" {
                            if connector.connectorType == .ccsType2Combo {
                                filteredDevices.append(chargeDevice)
                            }
                        } else if connectorFilter.connector == "Type2Tesla" {
                            if connector.connectorType == .type2Tesla {
                                filteredDevices.append(chargeDevice)
                            }
                        } else if connectorFilter.connector == "Commando2PE" {
                            if connector.connectorType == .commando2PE {
                                filteredDevices.append(chargeDevice)
                            }
                        } else if connectorFilter.connector == "Commando3PNE" {
                            if connector.connectorType == .commando3PNE {
                                filteredDevices.append(chargeDevice)
                            }
                        }
                    }
                }
            }
        }
    }

    func filterDevicesByChargerType(chargeDevices: [ChargeDevice]) {
        let slowCharge  = 3.0...5.0
        let fastCharge  = 7.0...36.0
        let rapidCharge = 43.0...350

        for chargeDevice in chargeDevices {
            if filteredDevices.contains(chargeDevice) == false {
                let connectors = chargeDevice.connector
                for connector in connectors {

                    if chargerData.selectedSpeed == "Slow" && slowCharge ~= connector.ratedOutputkW {
                        filteredDevices.append(chargeDevice)
                    } else if chargerData.selectedSpeed == "Fast" && fastCharge ~= connector.ratedOutputkW  {
                        filteredDevices.append(chargeDevice)
                    } else if chargerData.selectedSpeed == "Rapid+" && connector.ratedOutputkW > 36.0  {
                        filteredDevices.append(chargeDevice)
                    }

                    if chargerData.selectedMethod == "Single Phase AC" && connector.chargeMethod == .singlePhaseAc {
                        filteredDevices.append(chargeDevice)
                    } else if chargerData.selectedMethod == "Three Phase AC" && connector.chargeMethod == .threePhaseAc {
                        filteredDevices.append(chargeDevice)
                    } else if chargerData.selectedMethod == "DC" && connector.chargeMethod == .dc {
                        filteredDevices.append(chargeDevice)
                    }

                    if chargerData.tetheredCable && connector.tetheredCable == true {
                        filteredDevices.append(chargeDevice)
                    }
                }
            }
        }
    }

    func filterByNetwork(chargeDevices: [ChargeDevice], networkData: [NetworkData]) {
        let networkFilters: [NetworkData] = networkData.filter { $0.setting == true }
        for networkFilter in networkFilters {
            filteredDevices.append(contentsOf: chargeDevices.filter { $0.deviceNetworks.contains(networkFilter.network) })
        }
    }
}
