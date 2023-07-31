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

    var body: some View {
        VStack {
            Form {
                Section("Network") {
                    ForEach($vm.networkFilters) { filter in
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
    NetworkFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
