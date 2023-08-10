//
//  EVChargePointsApp.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

@main
struct EVChargePointsApp: App {

    // Create a delegate to check for when performing UI Testing
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage(UserDefaultKeys.tabSelection) private var tabSelection = Tabs.map

    @StateObject private var dataManager = DataManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var routerManager = NavigationRouter()

    init() {
        copyJSONFilesOnFirstLaunch(isFirstLaunch: &isFirstLaunch)
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

                SettingsView()
                    .tabItem {
                        Label(Tabs.settings.label, systemImage: Tabs.settings.icon)
                    }
                    .tag(Tabs.settings)
            }
            .tint(.accentColor)
        }
        .environmentObject(dataManager)
        .environmentObject(locationManager)
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

extension EVChargePointsApp {

    private func copyJSONFilesOnFirstLaunch(isFirstLaunch: inout Bool) {
        if isFirstLaunch {
            for JSONFile in JSONFiles.allCases {
                copyFileToDocumentsFolder(nameForFile: JSONFile.rawValue, extForFile: "json")
            }
            isFirstLaunch = false
        }
    }

    private func copyFileToDocumentsFolder(nameForFile: String, extForFile: String) {
        let documentsURL = FileManager.documentsDirectory
        let destURL = documentsURL.appendingPathComponent(nameForFile).appendingPathExtension(extForFile)
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

extension EVChargePointsApp {
    enum JSONFiles: String, CaseIterable {
        case access     = "AccessData"
        case charger    = "ChargerData"
        case connector  = "ConnectorData"
        case location   = "LocationData"
        case network    = "NetworkData"
        case payment    = "PaymentData"
    }
}
