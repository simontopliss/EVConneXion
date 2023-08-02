//
//  FiltersViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation
import SwiftUI

final class FiltersViewModel: ObservableObject {

    @Published var accessData: [AccessData] = []
    @Published var chargerData: ChargerData = ChargerData()
    @Published var locationData: [LocationData] = []
    @Published var paymentData: [PaymentData] = []

    init() {
        /// Load JSON files
        loadAccessData()
        loadLocationData()
        loadPaymentData()
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
