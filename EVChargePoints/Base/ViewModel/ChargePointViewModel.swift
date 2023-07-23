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
        chargeDevices = ChargePointData.mockChargeDevices
        loadNetworkGraphics()
    }

    // MARK: - Address formatting

    func createAddress(chargeDevice: ChargeDevice) -> Address {
        address = Address(chargeDeviceLocation: chargeDevice.chargeDeviceLocation)
        return address!
    }

    // MARK: - Network Graphics

    /// Loads the network graphics from a JSON file
    func loadNetworkGraphics() {
        networkGraphics = try! StaticJSONMapper.decode(
            file: "NetworkGraphics",
            type: [NetworkGraphic].self
        )
    }

    /// Split networks separated by comma if there's multiple
    /// - Parameter deviceNetworks: String
    /// - Returns: array of Strings
    func separate(deviceNetworks: String) -> [String] {
        var networks: [String] = []
        if deviceNetworks.contains(",") {
            networks = deviceNetworks.components(separatedBy: ",")
        } else {
            networks = [deviceNetworks]
        }
        return networks
    }

    /// Separates a comma-separated string of device networks by separator
    /// - Parameters:
    ///   - deviceNetworks: String
    ///   - by: the String to separate by
    /// - Returns: an array of Strings
    func separate(deviceNetworks: String, by: String) -> String {
        let networks = separate(deviceNetworks: deviceNetworks)
        var displayNames: [String] = []
        for network in networks {
            displayNames.append(displayNameFor(network: network))
        }
        return displayNames.joined(separator: by)
    }

    /// Description returns the svg or png for a given attribution
    /// - Parameter attribution: String
    /// - Returns: name of the corresponding network graphic from NetworkGraphics.json
    func networkGraphicFor(attribution: String) -> String {
        let item = networkGraphics.first { $0.network == attribution }
        guard let filename = item?.filename else { return "default-network-128x128" }
        let fileURL = URL(string: filename)!
        return fileURL.deletingPathExtension().lastPathComponent
    }

    /// Description returns the svg or png for a given attribution
    /// - Parameter network: network String
    /// - Returns: name of the corresponding network graphic from NetworkGraphics.json
    func networkGraphicFor(network: String) -> String {
        let item = networkGraphics.first { $0.network == network }
        guard let filename = item?.filename else { return "default-network-128x128" }
        let fileURL = URL(string: filename)!
        return fileURL.deletingPathExtension().lastPathComponent
    }

    /// Gets the shortened display name for a network
    /// - Parameter network: network String
    /// - Returns: the shorter display name from NetworkGraphics.json
    func displayNameFor(network: String) -> String {
        let item = networkGraphics.first { $0.network == network }
        guard let displayName = item?.displayName else { return network }
        return displayName
    }

    /// Returns the connector graphics and total for each connector
    /// - Parameter connectors: array connectors of a charge device
    /// - Returns: Array of structs of ConnectorGraphic
    func graphicsAndCountsFor(connectors: [Connector]) -> [ConnectorGraphic] {

        var connectorGraphics: [String] = []
        var connectorGraphicsAndCounts: [ConnectorGraphic] = []

        for connector in connectors {
            let connectorType = connector.connectorType.rawValue // + ".svg"
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

    func networkColorFor(network: String) -> Color? {
        let item = networkGraphics.first { $0.network == network }
        guard let rgbValues = item?.rgbValues else { return nil }
        let networkColor = Color(
            UIColor(
                r: CGFloat(rgbValues.red),
                g: CGFloat(rgbValues.green),
                b: CGFloat(rgbValues.blue)
            )
        )
        return networkColor
    }

    // MARK: - API Call

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
