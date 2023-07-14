//
//  ChargePointViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//

// import Observation
import SwiftUI

// @Observable
final class ChargePointViewModel: ObservableObject {

    // MARK: - PROPERTIES

    @Published var chargeDevices: [ChargeDevice] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published private(set) var isLoading = false
    @Published var hasError = false

    private(set) var address: Address?

    // MARK: - FILTERS
    // TODO: Need to be able to choose 1 or multiple connector types
    // API can only search for 1 at a time, so filter results instead
    // private var connectorTypes = ConnectorType.allCases

    private var distance = 2
    private var limit = 5
    private var units: Endpoint.RegistryDataType.Unit = .mi
    private var country: Endpoint.RegistryDataType.Country = .gb

    // Dependency Injection of NetworkManagerImpl protocol
    private let networkManager: NetworkManagerImpl! // swiftlint:disable:this implicitly_unwrapped_optional

    // Constructor uses DI for testing
    init(networkManager: NetworkManagerImpl = NetworkManager.shared) {
        self.networkManager = networkManager
        self.chargeDevices = ChargePointData.mockChargeDevices
    }

    func createAddress(chargeDevice: ChargeDevice) -> Address {
        self.address = Address(chargeDeviceLocation: chargeDevice.chargeDeviceLocation)
        return address!
    }

    @MainActor
    func fetchChargeDevices(requestType: Endpoint.RequestType) async {

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
            let chargePointData = try await NetworkManager.shared.request(url, type: ChargePointData.self)
            chargeDevices = chargePointData.chargeDevices
            // dump(chargePointData.chargeDevices[0])
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
