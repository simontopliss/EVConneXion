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

    var body: some View {
        Form {
            Section("Connector") {
                ForEach($vm.connectorFilters) { filter in
                    Toggle(isOn: filter.setting) {
                        Text(filter.displayName.wrappedValue)
                            .foregroundStyle(AppColors.textColor)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    ConnectorFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
