//
//  NetworkFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct NetworkFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var vm: FiltersViewModel
    @EnvironmentObject private var chargePointViewModel: ChargePointViewModel

    var body: some View {
        Form {
            Section("Network") {
                // TODO: Would user want to sort this list?
                ForEach($vm.networkFilters) { filter in
                    Toggle(isOn: filter.setting) {
                        HStack {
                            Image(
                                chargePointViewModel.networkGraphicFor(network: filter.dataName.wrappedValue)
                            )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 60, maxHeight: 30, alignment: .leading)

                            Text(filter.displayName.wrappedValue)
                                .foregroundStyle(AppColors.textColor)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    NetworkFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
        .environmentObject(ChargePointViewModel())
}
