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

    @StateObject var chargePointViewModel = ChargePointViewModel()
    @StateObject private var routerManager = NavigationRouter()

    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelection) {
                MapView()
                    .tabItem {
                        VStack {
                            Text(Tabs.map.label)
                                .fontWeight(.semibold)
                            Image(systemName: Tabs.map.icon)
                        }
                    }
                    .tag(Tabs.map)
                    .environmentObject(chargePointViewModel)
                    .environmentObject(routerManager)

                ChargePointListView()
                    .tabItem {
                        VStack {
                            Text(Tabs.list.label)
                                .fontWeight(.semibold)
                            Image(systemName: Tabs.list.icon)
                        }
                    }
                    .tag(Tabs.list)
                    .environmentObject(chargePointViewModel)
                    .environmentObject(routerManager)

                RoutesView()
                    .tabItem {
                        VStack {
                            Text(Tabs.routes.label)
                                .fontWeight(.semibold)
                            Image(systemName: Tabs.routes.icon)
                        }
                        Label(
                            Tabs.routes.label,
                            systemImage: Tabs.routes.icon
                        )
                    }
                    .tag(Tabs.routes)
                    .environmentObject(chargePointViewModel)
                    .environmentObject(routerManager)

                SettingsView()
                    .tabItem {
                        VStack {
                            Text(Tabs.settings.label)
                                .fontWeight(.semibold)
                            Image(systemName: Tabs.settings.icon)
                        }
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
