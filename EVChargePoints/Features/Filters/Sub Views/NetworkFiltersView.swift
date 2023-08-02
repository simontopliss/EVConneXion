//
//  NetworkFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct NetworkFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var filtersViewModel: FiltersViewModel
    @EnvironmentObject private var chargePointViewModel: ChargePointViewModel

    var body: some View {
        Form {
            Section("Network") {
                // TODO: Would user want to sort this list?
                ForEach($chargePointViewModel.networkData) { filter in
                    HStack {
                        SymbolImage(
                            imageName: filter.graphicName.wrappedValue,
                            imageWidth: 60.0,
                            imageHeight: 40.0,
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
    NetworkFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
        .environmentObject(ChargePointViewModel())
}
