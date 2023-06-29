//
//  ChargePointViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//

import Foundation

final class ChargePointViewModel: ObservableObject {

    // MARK: - PROPERTIES

    @Published var chargeDevices: [ChargeDevice] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published private(set) var isLoading = false
    @Published var hasError = false

    let networkManager = NetworkManager()

    // MARK: - FILTERS
    // TODO:  Store in User Defaults
    
    private var distance = UInt(10)
    private var limit = UInt(0)
    // private var connectorTypes = ConnectorType.allCases
    private var unit: Endpoint.RegistryDataType.Unit = .mi
    private var country: Endpoint.RegistryDataType.Country = .gb

    @MainActor
    func fetchChargeDevices(requestType: Endpoint.RequestType) async {

        // let url = "https://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/HP19+8FF/dist/10/format/json"

        let url = Endpoint.buildURL(
            requestType: requestType,
            distance: distance,
            limit: limit,
            unit: unit,
            country: country
        )

        print(url)

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
