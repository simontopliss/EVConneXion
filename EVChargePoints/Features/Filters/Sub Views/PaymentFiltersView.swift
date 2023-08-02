//
//  PaymentFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct PaymentFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var filtersViewModel: FiltersViewModel

    var body: some View {
        Form {
            Section("Payment") {
                ForEach($filtersViewModel.paymentData) { filter in
                   ToggleWithSymbol(
                        displayName: filter.displayName.wrappedValue,
                        symbolName: filter.symbol.wrappedValue,
                        toggled: filter.setting
                    )
                }
            }
        }
    }
}

#Preview {
    PaymentFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
