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
                            dataManager.saveSettings(.network)
                        }
                    }
                }
                .font(.headline)
                .foregroundStyle(AppColors.textColor)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    NetworkFiltersView()
        .environmentObject(DataManager())
}
