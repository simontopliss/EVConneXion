//
//  UserSettingsView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct UserSettingsView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var dataManager: DataManager

    var body: some View {
        VStack {
            // TODO: Add user settings
            Text("Miles or Kilometres")
        }
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

#Preview {
    UserSettingsView()
}

final class UserSettingsViewModel: ObservableObject {}
