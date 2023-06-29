//
//  EVChargePointsApp.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

@main
struct EVChargePointsApp: App {

    @AppStorage(UserDefaultKeys.tabSelection) private var tabSelection = TabModel.map

    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelection) {
                MapView()
                    .tabItem {
                        Label(
                            TabModel.map.label,
                            systemImage: TabModel.map.icon
                        )
                    }
                    .tag(TabModel.map)

                ChargePointListView()
                    .tabItem {
                        Label(
                            TabModel.list.label,
                            systemImage: TabModel.list.icon
                        )
                    }
                    .tag(TabModel.list)

                RoutesView()
                    .tabItem {
                        Label(
                            TabModel.routes.label,
                            systemImage: TabModel.routes.icon
                        )
                    }
                    .tag(TabModel.routes)

                SettingsView()
                    .tabItem {
                        Label(
                            TabModel.settings.label,
                            systemImage: TabModel.settings.icon
                        )
                    }
                    .tag(TabModel.settings)
            }
        }
    }
}
