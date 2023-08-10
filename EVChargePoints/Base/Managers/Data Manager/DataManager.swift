import Foundation
import SwiftUI

final class DataManager: ObservableObject {

    @Published var chargeDevices: [ChargeDevice] = []
    @Published var networkData: [NetworkData] = []
    @Published var connectorData: [ConnectorData] = []

    @Published var distance: Double = 10.0
    @Published var units: Endpoint.RegistryDataType.Unit = .mi

    @Published private(set) var error: NetworkManager.NetworkError?
    @Published private(set) var isLoading = false
    @Published var hasError = false

    @Published var accessData: [AccessData] = []
    @Published var chargerData: ChargerData = .init()
    @Published var locationData: [LocationData] = []
    @Published var paymentData: [PaymentData] = []
    @Published var filteredDevices: [ChargeDevice] = []

    @Published var filtersChanged = false

    // TODO: Is `limit` required?
    private(set) var limit = 0
    private(set) var country: Endpoint.RegistryDataType.Country = .gb

    // Dependency Injection of NetworkManagerImpl protocol
    private let networkManager: NetworkManagerImpl! // swiftlint:disable:this implicitly_unwrapped_optional

    // Constructor uses DI for testing
    init(networkManager: NetworkManagerImpl = NetworkManager.shared) {
        self.networkManager = networkManager

        self.chargeDevices = sortAndRemoveDuplicateDevices(devices: ChargePointData.mockChargeDevices)

        // Load JSON files
        loadAccessData()
        loadChargerData()
        loadConnectorTypes()
        loadLocationData()
        loadNetworkData()
        loadPaymentData()
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

    func loadAccessData() {
        accessData = try! StaticJSONMapper.decode(
            file: "AccessData",
            type: [AccessData].self,
            location: .documents
        )
    }

    func loadChargerData() {
        chargerData = try! StaticJSONMapper.decode(
            file: "ChargerData",
            type: ChargerData.self,
            location: .documents
        )
    }

    func loadLocationData() {
        locationData = try! StaticJSONMapper.decode(
            file: "LocationData",
            type: [LocationData].self,
            location: .documents
        )
    }

    func loadPaymentData() {
        paymentData = try! StaticJSONMapper.decode(
            file: "PaymentData",
            type: [PaymentData].self,
            location: .documents
        )
    }

    func saveSettings(_ jsonFile: EVChargePointsApp.JSONFiles) {
        filtersChanged = true
        switch jsonFile {
            case .access:
                AccessData.saveData(data: accessData)
            case .charger:
                ChargerData.saveData(data: chargerData)
            case .connector:
                ConnectorData.saveData(data: connectorData)
            case .location:
                LocationData.saveData(data: locationData)
            case .network:
                NetworkData.saveData(data: networkData)
            case .payment:
                PaymentData.saveData(data: paymentData)
        }
    }
}

// MARK: - Filters


