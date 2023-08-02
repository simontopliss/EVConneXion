//
//  AccessFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct AccessFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var filtersViewModel: FiltersViewModel

    var body: some View {
        Form {
            Section("Access") {
                ForEach($filtersViewModel.accessData) { filter in
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
    AccessFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
