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
                    // TODO: I think I need to change the corresponding Method/Speed depending on what is selected.
                    // E.g. If DC is selected should the speed be set to Fast at a minimum?
                    Picker("Method", selection: $vm.chargerFilter.selectedMethod) {
                        ForEach(vm.chargerFilter.chargeMethods, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Speed", selection: $vm.chargerFilter.selectedSpeed) {
                        ForEach(vm.chargerFilter.chargeSpeeds, id: \.self) {
                            Text($0)
                        }
                    }
                    // If DC is selected, should tethered by selected too?
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
