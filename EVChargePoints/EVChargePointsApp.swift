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

    @StateObject private var chargePointViewModel  = ChargePointViewModel()
    @StateObject private var routerManager         = NavigationRouter()
    @StateObject private var locationManager       = LocationManager()
    @StateObject private var filtersViewModel      = FiltersViewModel()

    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelection) {
                MapView()
                    .tabItem {
                        Label(Tabs.map.label, systemImage: Tabs.map.icon)
                    }
                    .tag(Tabs.map)
                    .environmentObject(chargePointViewModel)
                    .environmentObject(routerManager)
                    .environmentObject(locationManager)
                    .environmentObject(filtersViewModel)

                ChargePointListView()
                    .tabItem {
                        Label(Tabs.list.label, systemImage: Tabs.list.icon)
                    }
                    .tag(Tabs.list)
                    .environmentObject(chargePointViewModel)
                    .environmentObject(routerManager)
                    .environmentObject(locationManager)
                    .environmentObject(filtersViewModel)

                FiltersView()
                    .tabItem {
                        Label(Tabs.routes.label, systemImage: Tabs.routes.icon)
                    }
                    .tag(Tabs.routes)
                    .environmentObject(chargePointViewModel)
                    .environmentObject(routerManager)
                    .environmentObject(filtersViewModel)

                SettingsView()
                    .tabItem {
                        Label(Tabs.settings.label, systemImage: Tabs.settings.icon)
                    }
                    .tag(Tabs.settings)
            }
            .tint(.accentColor)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                appearance.backgroundColor = UIColor(Color.gray.opacity(0.1))
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
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
