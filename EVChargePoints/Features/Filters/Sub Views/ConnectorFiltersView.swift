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
                    Toggle(isOn: filter.setting) {
                        HStack {
                            Image(filter.dataName.wrappedValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 30, maxHeight: 30, alignment: .center)
                            .padding(.trailing, 6)

                            Text(filter.displayName.wrappedValue)
                        }
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
