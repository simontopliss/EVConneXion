//
//  EVChargePointsApp.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

@main
struct EVChargePointsApp: App {

    var body: some Scene {
        WindowGroup {
            TabView {
                MapView()
                    .tabItem {
                        Label(
                            Constants.Tab.map.label,
                            systemImage: Constants.Tab.map.icon
                        )
                    }
                ChargePointListView()
                    .tabItem {
                        Label(
                            Constants.Tab.list.label,
                            systemImage: Constants.Tab.list.icon
                        )
                    }
                RoutesView()
                    .tabItem {
                        Label(
                            Constants.Tab.routes.label,
                            systemImage: Constants.Tab.routes.icon
                        )
                    }
                SettingsView()
                    .tabItem {
                        Label(
                            Constants.Tab.settings.label,
                            systemImage: Constants.Tab.settings.icon
                        )
                    }
            }
        }
    }
}
