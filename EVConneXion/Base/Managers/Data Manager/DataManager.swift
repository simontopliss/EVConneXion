import Foundation
import SwiftUI

@MainActor
final class DataManager: ObservableObject {

    /// Main Data
    @Published var chargeDevices: [ChargeDevice] = []
    @Published var filteredDevices: [ChargeDevice] = []

    @Published var networkData: [NetworkData] = []
    @Published var connectorData: [ConnectorData] = []
    @Published var accessData: [AccessData] = []
    @Published var chargerData: ChargerData = .init()
    @Published var locationData: [LocationData] = []
    @Published var paymentData: [PaymentData] = []
    @Published var userSettings: UserSettings!

    var postcodes: [Postcode]!

    @Published var recentSearches: [RecentSearch] = []

    /// Network Manager
    @Published private(set) var networkError: NetworkManager.NetworkError?
    @Published private(set) var isLoading = false
    @Published var hasNetworkError = false

    /// Filter Settings
    @Published var filtersChanged = false
    @Published var filterResultError = false
    @Published var filterResultErrorMessage = ""

    /// Search
    @Published var searchError: SearchError?
    @Published var hasSearchError = false
//    @Published var searchErrorMessage = ""
//    @Published var searchQuery: String = "" {
//        didSet {
//            // TODO: filter recentSearches for match
//        }
//    }

    // TODO: Is `limit` required?
    private(set) var limit = 0

    // Dependency Injection of NetworkManagerImpl protocol
    private let networkManager: NetworkManagerImpl! // swiftlint:disable:this implicitly_unwrapped_optional

    // Constructor uses DI for testing
    init(networkManager: NetworkManagerImpl = NetworkManager.shared) {
        self.networkManager = networkManager

        // chargeDevices = sortAndRemoveDuplicateDevices(devices: ChargePointData.mockChargeDevices)
        // filteredDevices = chargeDevices

        // Load JSON files
        loadAccessData()
        loadChargerData()
        loadConnectorTypes()
        loadLocationData()
        loadNetworkData()
        loadPaymentData()
        loadUserSettings()
        loadRecentSearches()
        loadPostcodes()
    }

    // MARK: - API Call

    func fetchChargeDevices(requestType: ChargePointsEndpoint.RequestType) async {
        print(#function)

        var url = ""

        if requestType == ChargePointsEndpoint.RequestType.latLong(
            LocationManager.defaultLocation.latitude,
            LocationManager.defaultLocation.longitude
        )
            && LocationManager.shared.userLocation == LocationManager.defaultLocation
        {
            /// Limit the amount of charge points returned on the first launch
            url = ChargePointsEndpoint.buildURL(
                requestType: requestType,
                distance: 2.0,
                limit: 250,
                units: userSettings.unitSetting,
                country: userSettings.countrySetting
            )
        } else {
            url = ChargePointsEndpoint.buildURL(
                requestType: requestType,
                distance: userSettings.distance,
                limit: limit,
                units: userSettings.unitSetting,
                country: userSettings.countrySetting
            )
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let chargePointData = try await NetworkManager.shared.request(url, type: ChargePointData.self)
            chargeDevices = sortAndRemoveDuplicateDevices(devices: chargePointData.chargeDevices)
            // chargeDevices = chargePointData.chargeDevices
            print("chargeDevices count: \(chargeDevices.count)")
            applyFilters()
            print("chargeDevices count after filtering: \(chargeDevices.count)")
            /// Limit to 250 Charge Devices as it severely affects SwiftUI Maps performance
            filteredDevices = Array(chargeDevices.prefix(250))
            print("filteredDevices count: \(filteredDevices.count)")
            guard let deviceMapItem = chargeDevices.first?.deviceMapItem else {
                LocationManager.shared.searchRegion = nil
                return
            }
            LocationManager.shared.searchRegion(coordinate: deviceMapItem.coordinate)
            // dump(chargePointData.chargeDevices[0])
        } catch {
            hasNetworkError = true
            if let networkError = error as? NetworkManager.NetworkError {
                self.networkError = networkError
            } else {
                networkError = .custom(error: error)
            }
        }
    }

    private func loadAccessData() {
        accessData = try! StaticJSONMapper.decode(
            file: EVConneXionApp.JSONFiles.access.rawValue,
            type: [AccessData].self,
            location: .documents
        )
    }

    private func loadChargerData() {
        chargerData = try! StaticJSONMapper.decode(
            file: EVConneXionApp.JSONFiles.charger.rawValue,
            type: ChargerData.self,
            location: .documents
        )
    }

    private func loadLocationData() {
        locationData = try! StaticJSONMapper.decode(
            file: EVConneXionApp.JSONFiles.location.rawValue,
            type: [LocationData].self,
            location: .documents
        )
    }

    private func loadPaymentData() {
        paymentData = try! StaticJSONMapper.decode(
            file: EVConneXionApp.JSONFiles.payment.rawValue,
            type: [PaymentData].self,
            location: .documents
        )
    }

    private func loadUserSettings() {
        userSettings = try! StaticJSONMapper.decode(
            file: EVConneXionApp.JSONFiles.userSettings.rawValue,
            type: UserSettings.self,
            location: .documents
        )
    }

    private func loadRecentSearches() {
        recentSearches = try! StaticJSONMapper.decode(
            file: EVConneXionApp.JSONFiles.recentSearches.rawValue,
            type: [RecentSearch].self,
            location: .documents
        )
    }

    private func loadPostcodes() {
        postcodes = try! StaticJSONMapper.decode(
            file: "uk-postcodes",
            type: [Postcode].self,
            location: .bundle
        )
    }

    func saveSettings(_ jsonFile: EVConneXionApp.JSONFiles) {
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
            case .recentSearches:
                RecentSearch.saveData(data: recentSearches)
        }
        filtersChanged = true
    }

    // TODO: Add Network, Location etc
    func anyConnectorSelected() -> Bool {
        return connectorData.first(where: { $0.setting == true }) != nil
    }
}
