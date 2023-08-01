//
//  ConnectorFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct ConnectorFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var vm: FiltersViewModel
    @EnvironmentObject private var chargePointViewModel: ChargePointViewModel

    var body: some View {
        Form {
            Section("Connector") {
                ForEach($vm.connectorFilters) { filter in
                    HStack {
                        SymbolImage(
                            imageName: filter.dataName.wrappedValue,
                            toggled: filter.setting
                        )
                        Toggle(isOn: filter.setting) {
                            Text(filter.displayName.wrappedValue)
                        }
                        .tag(filter.id)
                    }
                }
                .font(.headline)
                .foregroundColor(AppColors.textColor)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    ConnectorFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
        .environmentObject(ChargePointViewModel())
}
