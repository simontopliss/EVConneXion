//
//  ConnectorFiltersView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct ConnectorFiltersView: View {

    @EnvironmentObject private var dataManager: DataManager
    @State private var showAlert = false

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
                        anyConnectorSelected()
                        ? dataManager.saveSettings(.connector)
                        : showAlert.toggle()
                    }
                }
            }
        }
        .alert("No connector selected!", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You must select at least one connector to filter by.")
        }
    }

    private func anyConnectorSelected() -> Bool {
        dataManager.connectorData.first(where: { $0.setting == true }) != nil
    }
}

#Preview {
    ConnectorFiltersView()
        .environmentObject(DataManager())
}
