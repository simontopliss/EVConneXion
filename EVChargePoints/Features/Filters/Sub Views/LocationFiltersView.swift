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
        Form {
            Section("Location") {
                ForEach($vm.locationFilters) { filter in
                    HStack {
                        SymbolImage(
                            imageName: filter.symbol.wrappedValue,
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
    LocationFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
