//
//  NetworkFiltersView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct NetworkFiltersView: View {

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var dataManager: DataManager
    @State private var showAlert = false

    var body: some View {
        Form {
            Section("Network") {
                // TODO: Would user want to sort this list?
                ForEach($dataManager.networkData) { filter in
                    HStack {
                        SymbolImageAnimated(
                            graphicName: (
                                colorScheme == .dark
                                ? filter.graphicName.wrappedValue + "-i"
                                : filter.graphicName.wrappedValue
                            ),
                            symbolWidth: 60.0,
                            symbolHeight: 40.0,
                            toggled: filter.setting
                        )

                        Toggle(isOn: filter.setting) {
                            Text(filter.displayName.wrappedValue)
                        }
                        .tag(filter.id)
                        .onChange(of: filter.setting.wrappedValue) {
                            anyNetworkSelected()
                            ? dataManager.saveSettings(.network)
                            : showAlert.toggle()
                        }
                    }
                }
                .font(.headline)
                .foregroundStyle(AppColors.textColor)
                .padding(.vertical, 4)
            }
        }
        .alert("No network selected!", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You must select at least one network to filter by.")
        }
    }

    private func anyNetworkSelected() -> Bool {
        dataManager.networkData.first(where: { $0.setting == true }) != nil
    }
}

#Preview {
    NetworkFiltersView()
        .environmentObject(DataManager())
}
