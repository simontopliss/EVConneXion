//
//  FiltersViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation
import SwiftUI

final class FiltersViewModel: ObservableObject {

    @Published var accessFilters: [AccessFilter] = []
    @Published var chargerFilter: ChargerFilter = ChargerFilter()
    @Published var connectorFilters: [ConnectorFilter] = []
    @Published var locationFilters: [LocationFilter] = []
    @Published var networkFilters: [NetworkFilter] = []
    @Published var paymentFilters: [PaymentFilter] = []

    init() {
        /// Load JSON files
        loadAccessFilters()
        loadConnectorFilters()
        loadLocationFilters()
        loadNetworkFilters()
        loadPaymentFilters()
    }

    func loadAccessFilters() {
        self.accessFilters = try! StaticJSONMapper.decode(
            file: "AccessFilter",
            type: [AccessFilter].self
        )
    }

    func loadConnectorFilters() {
        self.connectorFilters = try! StaticJSONMapper.decode(
            file: "ConnectorFilter",
            type: [ConnectorFilter].self
        )
    }

    func loadLocationFilters() {
        self.locationFilters = try! StaticJSONMapper.decode(
            file: "LocationFilter",
            type: [LocationFilter].self
        )
    }

    func loadNetworkFilters() {
        self.networkFilters = try! StaticJSONMapper.decode(
            file: "NetworkFilter",
            type: [NetworkFilter].self
        )
        self.networkFilters.sort { $0.total > $1.total }
    }

    func loadPaymentFilters() {
        self.paymentFilters = try! StaticJSONMapper.decode(
            file: "PaymentFilter",
            type: [PaymentFilter].self
        )
    }
}
