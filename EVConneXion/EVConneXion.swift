//
//  EVConneXionApp.swift
//  EVConneXion
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

@main
struct EVConneXionApp: App {

    // Create a delegate to check for when performing UI Testing
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var dataManager = DataManager()
    @StateObject private var routerManager = NavigationRouter()

    //    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage(UserDefaultKeys.tabSelection) private var tabSelection = Tabs.map

    init() {
        copyJSONFilesOnFirstLaunch()
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelection) {
                MapView()
                    .tabItem {
                        Label(Tabs.map.label, systemImage: Tabs.map.icon)
                    }
                    .tag(Tabs.map)

                ChargePointListView()
                    .tabItem {
                        Label(Tabs.list.label, systemImage: Tabs.list.icon)
                    }
                    .tag(Tabs.list)

                FiltersView()
                    .tabItem {
                        Label(Tabs.filters.label, systemImage: Tabs.filters.icon)
                    }
                    .tag(Tabs.filters)

                UserSettingsView()
                    .tabItem {
                        Label(Tabs.settings.label, systemImage: Tabs.settings.icon)
                    }
                    .tag(Tabs.settings)

            }
            .tint(.accentColor)
        }
        .environmentObject(locationManager)
        .environmentObject(dataManager)
        .environmentObject(routerManager)
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        #if DEBUG
        if UITestingHelper.isUITesting { print("👷🏻‍♂️ UI Testing") }
        #endif
        return true
    }
}

extension EVConneXionApp {

    private func copyJSONFilesOnFirstLaunch() {
        for JSONFile in JSONFiles.allCases {
            copyFileToDocumentsFolder(nameForFile: JSONFile.rawValue, extForFile: "json")
        }
    }

    // TODO: Should this not be `private` so I can copy new JSON files if needed?
    private func copyFileToDocumentsFolder(nameForFile: String, extForFile: String) {
        let documentsURL = FileManager.documentsDirectory
        let destURL = documentsURL.appendingPathComponent(nameForFile).appendingPathExtension(extForFile)
        if !FileManager.default.fileExists(atPath: destURL.path) {
            guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile) else {
                print("Source file not found.")
                return
            }
            do {
                try FileManager.default.copyItem(at: sourceURL, to: destURL)
            } catch {
                print("Unable to copy file")
            }
        }
    }
}

extension EVConneXionApp {
    enum JSONFiles: String, CaseIterable {
        case access          = "AccessData"
        case charger         = "ChargerData"
        case connector       = "ConnectorData"
        case location        = "LocationData"
        case network         = "NetworkData"
        case payment         = "PaymentData"
        case userSettings    = "UserSettings"
        case recentSearches  = "RecentSearches"
    }

    enum Tabs: Int {

        case map
        case list
        case filters
        case settings

        var label: String {
            switch self {
                case .map:
                    return "Map"
                case .list:
                    return "List"
                case .filters:
                    return "Filters"
                case .settings:
                    return "Settings"
            }
        }

        var icon: String {
            switch self {
                case .map:
                    return "map"
                case .list:
                    return "list.bullet"
                case .filters:
                    return "slider.horizontal.3"
                case .settings:
                    return "gearshape"
            }
        }
    }
}

