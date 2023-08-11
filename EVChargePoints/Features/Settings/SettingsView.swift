//
//  SettingsView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct SettingsView: View {
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
    SettingsView()
}
