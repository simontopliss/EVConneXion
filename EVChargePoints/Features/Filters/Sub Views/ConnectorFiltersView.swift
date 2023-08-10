//
//  ConnectorFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct ConnectorFiltersView: View {

    @EnvironmentObject private var dataManager: DataManager

    var body: some View {
        Form {
            Section("Connector") {
                ForEach($dataManager.connectorData) { filter in
                    ToggleWithGraphic(
                        displayName: filter.displayName.wrappedValue,
                        graphicName: filter.graphicName.wrappedValue,
                        toggled: filter.setting,
                        itemID: filter.id
                    )
                    .onChange(of: filter.setting.wrappedValue) {
                        dataManager.saveSettings(.connector)
                    }
                }
            }
        }
    }
}

#Preview {
    ConnectorFiltersView()
        .environmentObject(DataManager())
}
