//
//  PaymentFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct PaymentFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var vm: FiltersViewModel

    var body: some View {
        Form {
            Section("Payment") {
                ForEach($vm.paymentFilters) { filter in
                    Toggle(isOn: filter.setting) {
                        Text(filter.displayName.wrappedValue)
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
    PaymentFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
