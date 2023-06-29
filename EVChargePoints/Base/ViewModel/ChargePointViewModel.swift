//
//  ChargePointViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//

import SwiftUI

final class ChargePointViewModel: ObservableObject {

    // MARK: - PROPERTIES

    @Published var chargeDevices: [ChargeDevice] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published private(set) var isLoading = false
    @Published var hasError = false

    let networkManager = NetworkManager()

    // MARK: - FILTERS

    // TODO: Need to be able to choose 1 or multiple connector types
    // API can only search for 1 at a time, so filter results instead
    // private var connectorTypes = ConnectorType.allCases

    @AppStorage(UserDefaultKeys.distance) private var distance = 10
    @AppStorage(UserDefaultKeys.limit) private var limit = 0
    @AppStorage(UserDefaultKeys.units) private var units: Endpoint.RegistryDataType.Unit = .mi
    @AppStorage(UserDefaultKeys.country) private var country: Endpoint.RegistryDataType.Country = .gb

    @MainActor
    func fetchChargeDevices(requestType: Endpoint.RequestType) async {

        // let url = "https://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/HP19+8FF/dist/10/format/json"

        let url = Endpoint.buildURL(
            requestType: requestType,
            distance: distance,
            limit: limit,
            units: units,
            country: country
        )

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await networkManager.request(url, type: ChargePointData.self)
            dump(result.chargeDevices[0])
        } catch {
            hasError = true
            if let networkError = error as? NetworkManager.NetworkError {
                self.error = networkError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}
