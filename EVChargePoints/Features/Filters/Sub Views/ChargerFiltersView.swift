//
//  ChargerFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

enum ChargerSettings: CaseIterable {
    case ratedOutputkW
    case ratedOutputVoltage
    case ratedOutputCurrent
    case chargeMethod
    case tetheredCable
}

struct ChargerFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var vm: FiltersViewModel

    var body: some View {
        VStack {
            Form {
                Section("Charger") {
                    Picker(
                        "Charge Method",
                        selection: $vm.chargerFilter.selectedChargeMethod
                    ) {
                        Text("Single Phase AC")
                            .tag("Single Phase AC")
                        Text("Three Phase AC")
                            .tag("Three Phase AC")
                        Text("DC")
                            .tag("DC")
                    }
                    Toggle(isOn: $vm.chargerFilter.tetheredCable) {
                        Text("Tethered Cable")
                    }
                }
                .foregroundStyle(AppColors.textColor)
            }
        }
    }
}

#Preview {
    ChargerFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}
