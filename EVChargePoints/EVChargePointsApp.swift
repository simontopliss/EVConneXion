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

    @AppStorage(UserDefaultKeys.tabSelection) private var tabSelection = Tabs.map

    @StateObject private var dataManager      = DataManager()
    @StateObject private var locationManager  = LocationManager()
    @StateObject private var routerManager    = NavigationRouter()

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
