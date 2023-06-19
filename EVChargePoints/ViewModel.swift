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
        dataType: Endpoint.DataType,
        registerDataTypes: [Endpoint.RegistryDataType],
        requestOption: Endpoint.RequestOption = .json
    ) async {
//        var url = Endpoint.baseURL.rawValue + dataType.rawValue
        let url = "https://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/HP19+8FF/dist/10/format/json"

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await NetworkManager.shared.request(url, type: ChargePointData.self)
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
