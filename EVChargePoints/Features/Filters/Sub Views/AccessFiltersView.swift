//
//  AccessFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct AccessFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var vm: FiltersViewModel

    var body: some View {
        Form {
            Section("Access") {
                ForEach($vm.accessFilters) { filter in
                    HStack {
                        SFSymbolImage(
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
    AccessFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
