//
//  PaymentFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct PaymentFiltersView: View {

    @EnvironmentObject private var dataManager: DataManager

    var body: some View {
        Form {
            Section("Payment") {
                ForEach($dataManager.paymentData) { filter in
                   ToggleWithSymbol(
                        displayName: filter.displayName.wrappedValue,
                        symbolName: filter.symbol.wrappedValue,
                        toggled: filter.setting,
                        itemID: filter.id
                    )
                   .onChange(of: filter.setting.wrappedValue) {
                       dataManager.saveSettings(.payment)
                   }
                }
            }
        }
    }
}

#Preview {
    PaymentFiltersView()
        .environmentObject(DataManager())
}
