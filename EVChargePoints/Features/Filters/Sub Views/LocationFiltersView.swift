//
//  LocationFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct LocationFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var filtersViewModel: FiltersViewModel

    var body: some View {
        Form {
            Section("Location") {
                ForEach($filtersViewModel.locationData) { filter in
                    ToggleWithGraphic(
                        displayName: filter.displayName.wrappedValue,
                        graphicName: filter.graphicName.wrappedValue,
                        toggled: filter.setting
                    )
                }
            }
        }
    }
}

#Preview {
    LocationFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
