//
//  LocationFiltersView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct LocationFiltersView: View {

    @EnvironmentObject private var dataManager: DataManager
    @State private var showAlert = false

    var body: some View {
        Form {
            Section("Location") {
                ForEach($dataManager.locationData) { filter in
                    ToggleWithGraphic(
                        displayName: filter.displayName.wrappedValue,
                        graphicName: filter.graphicName.wrappedValue,
                        toggled: filter.setting,
                        itemID: filter.id
                    )
                    .onChange(of: filter.setting.wrappedValue) {
                        anyLocationSelected()
                        ? dataManager.saveSettings(.location)
                        : showAlert.toggle()
                    }
                }
            }
        }
        .alert("No location selected!", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You must select at least one location to filter by.")
        }
    }

    private func anyLocationSelected() -> Bool {
        dataManager.locationData.first(where: { $0.setting == true }) != nil
    }
}

#Preview {
    LocationFiltersView()
        .environmentObject(DataManager())
}
