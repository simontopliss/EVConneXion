//
//  UserSettingsView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

final class UserSettingsViewModel: ObservableObject {}

struct UserSettingsView: View {

    @EnvironmentObject private var dataManager: DataManager

    @State private var unitChanged = false
    @State private var countryChanged = false

    var body: some View {
        Form {
            Section("Settings") {
                unitPicker()
                countryPicker()
            }
            .font(.headline)
            .foregroundStyle(AppColors.textColor)
            .padding(.vertical, 4)
        }
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

#Preview {
    UserSettingsView()
        .environmentObject(DataManager())
}

extension UserSettingsView {

    func unitPicker() -> some View {
        HStack {
            SFSymbolImageBounce(
                symbolName: Symbols.unitSymbolName,
                toggled: $unitChanged
            )

            Picker("Units", selection: $dataManager.userSettings.unitSetting) {
                Text(UserSettings.Unit.mi.rawValue)
                    .tag(UserSettings.Unit.mi)
                Text(UserSettings.Unit.km.rawValue)
                    .tag(UserSettings.Unit.km)
            }
            .onChange(of: dataManager.userSettings.unitSetting) {
                unitChanged.toggle()
                dataManager.saveSettings(.userSettings)
            }
        }
    }
}

extension UserSettingsView {

    func countryPicker() -> some View {
        HStack {
            SFSymbolImageBounce(
                symbolName: Symbols.countrySymbolName,
                toggled: $countryChanged
            )

            Picker("Country", selection: $dataManager.userSettings.countrySetting) {
                Text(UserSettings.Country.gb.rawValue)
                    .tag(UserSettings.Country.gb)
                Text(UserSettings.Country.ie.rawValue)
                    .tag(UserSettings.Country.ie)
            }
            .onChange(of: dataManager.userSettings.countrySetting) {
                countryChanged.toggle()
                dataManager.saveSettings(.userSettings)
            }
        }
    }
}
