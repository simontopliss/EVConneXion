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
}

//extension FiltersViewModel {
//    enum Filters: String, CaseIterable {
//        case access      = "Access"
//        case connectors  = "Connectors"
//        case locations   = "Locations"
//        case networks    = "Networks"
//        case payment     = "Payment"
//        case chargers    = "Chargers"
//    }
//}
