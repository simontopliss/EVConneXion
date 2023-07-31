//
//  LocationFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct LocationFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var vm: FiltersViewModel

    var body: some View {
        VStack {
            Form {
                Section("Location") {
                    ForEach($vm.locationFilters) { filter in
                        Toggle(isOn: filter.setting) {
                            Text(filter.displayName.wrappedValue)
                                .foregroundStyle(AppColors.textColor)
                        }
                    }
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
