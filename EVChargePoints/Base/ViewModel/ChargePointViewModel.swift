//
//  ChargePointViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//

// import Observation
import Foundation
import SwiftUI

// @Observable
final class ChargePointViewModel: ObservableObject {

    // MARK: - PROPERTIES

    @Published var chargeDevices: [ChargeDevice] = []
    @Published var networkGraphics: [NetworkGraphic] = []

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
        loadNetworkGraphics()
    }

    func loadNetworkGraphics() {
        self.networkGraphics = try! StaticJSONMapper.decode(
            file: "NetworkGraphics",
            type: [NetworkGraphic].self
        )
    }

    func getNetworkGraphicForAttribution(attribution: String) -> String {
        let item = networkGraphics.first { $0.network == attribution }
        guard let filename = item?.filename else { return "default-network-128x128" }
        let fileURL = URL(string: filename)!
        return fileURL.deletingPathExtension().lastPathComponent
    }

    func getNetworkDisplayName(attribution: String) -> String {
        let item = networkGraphics.first { $0.network == attribution }
        guard let displayName = item?.displayName else { return attribution }
        return displayName
    }

    func createAddress(chargeDevice: ChargeDevice) -> Address {
        self.address = Address(chargeDeviceLocation: chargeDevice.chargeDeviceLocation)
        return address!
    }

    func getConnectorGraphicsAndCounts(connectors: [Connector]) -> [ConnectorGraphic] {

        var connectorGraphics: [String] = []
        var connectorGraphicsAndCounts: [ConnectorGraphic] = []

        for connector in connectors {
            let connectorType = connector.connectorType.rawValue// + ".svg"
            if connectorGraphics.contains(connectorType) {
                for index in 0...connectorGraphicsAndCounts.count - 1 {
                    if connectorGraphicsAndCounts[index].name == connectorType {
                        connectorGraphicsAndCounts[index].count += 1
                    }
                }
            } else {
                connectorGraphics.append(connectorType)
                connectorGraphicsAndCounts.append(ConnectorGraphic(name: connectorType, count: 1))
            }
        }

        // dump(connectorGraphicsAndCounts)
        return connectorGraphicsAndCounts
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
