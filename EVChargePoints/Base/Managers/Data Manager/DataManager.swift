import Foundation
import SwiftUI

@MainActor
final class DataManager: ObservableObject {

    /// Main Data
    @Published var chargeDevices: [ChargeDevice] = []
    @Published var networkData: [NetworkData] = []
    @Published var connectorData: [ConnectorData] = []
    @Published var accessData: [AccessData] = []
    @Published var chargerData: ChargerData = .init()
    @Published var locationData: [LocationData] = []
    @Published var paymentData: [PaymentData] = []
    @Published var filteredDevices: [ChargeDevice] = []
    @Published var userSettings: UserSettings!

    /// Network Manager
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published private(set) var isLoading = false
    @Published var hasError = false

    /// Filter Settings
    @Published var filtersChanged = false
    @Published var filterResultError = false
    @Published var filterResultErrorMessage = ""

    /// Search
    @Published var searchError = false
    @Published var searchErrorMessage = ""
    @Published var searchQuery: String = "" {
        didSet {
            // TODO: filter recentSearches for match
        }
    }

    // TODO: Is `limit` required?
    private(set) var limit = 0

    // Dependency Injection of NetworkManagerImpl protocol
    private let networkManager: NetworkManagerImpl! // swiftlint:disable:this implicitly_unwrapped_optional

    // Constructor uses DI for testing
    init(networkManager: NetworkManagerImpl = NetworkManager.shared) {
        self.networkManager = networkManager

        chargeDevices = sortAndRemoveDuplicateDevices(devices: ChargePointData.mockChargeDevices)
        filteredDevices = chargeDevices

        // Load JSON files
        loadAccessData()
        loadChargerData()
        loadConnectorTypes()
        loadLocationData()
        loadNetworkData()
        loadPaymentData()
        loadUserSettings()
    }

    // MARK: - API Call

    // @MainActor
    func fetchChargeDevices(requestType: Endpoint.RequestType) async {

        let url = Endpoint.buildURL(
            requestType: requestType,
            distance: userSettings.distance,
            limit: limit,
            units: userSettings.unitSetting,
            country: userSettings.countrySetting
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

    private func loadAccessData() {
        accessData = try! StaticJSONMapper.decode(
            file: "AccessData",
            type: [AccessData].self,
            location: .documents
        )
    }

    private func loadChargerData() {
        chargerData = try! StaticJSONMapper.decode(
            file: "ChargerData",
            type: ChargerData.self,
            location: .documents
        )
    }

    private func loadLocationData() {
        locationData = try! StaticJSONMapper.decode(
            file: "LocationData",
            type: [LocationData].self,
            location: .documents
        )
    }

    private func loadPaymentData() {
        paymentData = try! StaticJSONMapper.decode(
            file: "PaymentData",
            type: [PaymentData].self,
            location: .documents
        )
    }

    private func loadUserSettings() {
        userSettings = try! StaticJSONMapper.decode(
            file: "UserSettings",
            type: UserSettings.self
        )
    }

    func saveSettings(_ jsonFile: EVChargePointsApp.JSONFiles) {
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
            case .userSettings:
                UserSettings.saveData(data: userSettings)
        }
        filtersChanged = true
    }

    // TODO: Add Network, Location etc
    func anyConnectorSelected() -> Bool {
        return connectorData.first(where: { $0.setting == true }) != nil
    }
}
