//
//  AccessFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct AccessFiltersView: View {

    @EnvironmentObject private var dataManager: DataManager

    var body: some View {
        Form {
            Section("Access") {
                ForEach($dataManager.accessData) { filter in
                    ToggleWithSymbol(
                        displayName: filter.displayName.wrappedValue,
                        symbolName: filter.symbol.wrappedValue,
                        toggled: filter.setting,
                        itemID: filter.id
                    )
                    .onChange(of: filter.setting.wrappedValue) {
                        dataManager.saveSettings(.access)
                    }
                }
            }
        }
    }
}

#Preview {
    AccessFiltersView()
        .environmentObject(DataManager())
}
