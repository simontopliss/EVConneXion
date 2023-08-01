//
//  ChargerFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct ChargerFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var vm: FiltersViewModel

    @State private var methodChanged = false
    @State private var speedChanged = false
    @State private var tetheredChanged = false

    var body: some View {
        Form {
            Section("Charger") {
                Group {
                    chargingMethod()
                    chargingSpeed()
                    tetheredCable()
                }
                .font(.headline)
                .foregroundColor(AppColors.textColor)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    ChargerFiltersView()
        .environmentObject(FiltersViewModel())
        .environmentObject(NavigationRouter())
}

extension ChargerFiltersView {

    func chargingMethod() -> some View {
        HStack {
            SFSymbolImage(
                imageName: vm.chargerFilter.chargeMethodsSymbol,
                toggled: $methodChanged
            )

            // TODO: I think I need to change the corresponding Method/Speed depending on what is selected.
            // E.g. If DC is selected should the speed be set to Fast at a minimum?
            Picker("Supply", selection: $vm.chargerFilter.selectedMethod) {
                ForEach(vm.chargerFilter.chargeMethods, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: vm.chargerFilter.selectedMethod) {
                methodChanged.toggle()
            }
        }
    }
}

extension ChargerFiltersView {

    func chargingSpeed() -> some View {
        HStack {
            SFSymbolImage(
                imageName: vm.chargerFilter.chargeSpeedsSymbol,
                toggled: $speedChanged
            )
            Picker("Charger Speed", selection: $vm.chargerFilter.selectedSpeed) {
                ForEach(vm.chargerFilter.chargeSpeeds, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: vm.chargerFilter.selectedSpeed) {
                speedChanged.toggle()
            }
        }
    }
}

extension ChargerFiltersView {

    func tetheredCable() -> some View {
        HStack {
            SFSymbolImage(
                imageName: vm.chargerFilter.tetheredCableSymbol,
                toggled: $tetheredChanged
            )
            // If DC is selected, should tethered by selected too?
            Toggle(isOn: $vm.chargerFilter.tetheredCable) {
                Text("Tethered Cable")
            }
            .onChange(of: vm.chargerFilter.tetheredCable) {
                tetheredChanged.toggle()
            }
        }
    }
}
