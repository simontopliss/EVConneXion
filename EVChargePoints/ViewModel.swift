//
//  ViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//

import Foundation

final class ViewModel: ObservableObject {

    // MARK: - PROPERTIES

    @Published var chargeDevices: [ChargeDevice] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published private(set) var isLoading = false
    @Published var hasError = false

    @MainActor
    func fetchChargeDevices(
        postcode: String,
        distance: UInt,
        limit: UInt = 0,
        connectorTypes: [ConnectorType] = ConnectorType.allCases,
        unit: Endpoint.RegistryDataType.Unit = .mi,
        country: Endpoint.RegistryDataType.Country = .gb
    ) async {
        //        let url = "https://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/HP19+8FF/dist/10/format/json"

        var urlComponents: [String] = []
        urlComponents.append(Endpoint.baseURL.rawValue)
        urlComponents.append(Endpoint.DataType.registry)
        urlComponents.append(Endpoint.RegistryDataType.postcode)
        urlComponents.append(postcode.replacingOccurrences(of: " ", with: "+"))
        urlComponents.append(Endpoint.RegistryDataType.dist)
        urlComponents.append("\(distance)")
        urlComponents.append(Endpoint.RegistryDataType.units)
        if limit > 0 { urlComponents.append("limit/\(limit)") }
        urlComponents.append(unit.rawValue)
        urlComponents.append(Endpoint.RequestOption.json.rawValue)

        let url = urlComponents.joined(separator: "/")

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await NetworkManager.shared.request(url, type: ChargePointData.self)
            dump(result.chargeDevices[0])
        } catch {
            self.hasError = true
            if let networkError = error as? NetworkManager.NetworkError {
                self.error = networkError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}
