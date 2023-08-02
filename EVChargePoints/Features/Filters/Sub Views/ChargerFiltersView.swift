//
//  ChargerFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct ChargerFiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var filtersViewModel: FiltersViewModel

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
                symbolName: filtersViewModel.chargerData.chargeMethodsSymbol,
                toggled: $methodChanged
            )

            // TODO: I think I need to change the corresponding Method/Speed depending on what is selected.
            // E.g. If DC is selected should the speed be set to Fast at a minimum?
            Picker("Supply", selection: $filtersViewModel.chargerData.selectedMethod) {
                ForEach(filtersViewModel.chargerData.chargeMethods, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: filtersViewModel.chargerData.selectedMethod) {
                methodChanged.toggle()
            }
        }
    }
}

extension ChargerFiltersView {

    func chargingSpeed() -> some View {
        HStack {
            SFSymbolImage(
                symbolName: filtersViewModel.chargerData.chargeSpeedsSymbol,
                toggled: $speedChanged
            )
            Picker("Charger Speed", selection: $filtersViewModel.chargerData.selectedSpeed) {
                ForEach(filtersViewModel.chargerData.chargeSpeeds, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: filtersViewModel.chargerData.selectedSpeed) {
                speedChanged.toggle()
            }
        }
    }
}

extension ChargerFiltersView {

    func tetheredCable() -> some View {
        HStack {
            SFSymbolImage(
                symbolName: filtersViewModel.chargerData.tetheredCableSymbol,
                toggled: $tetheredChanged
            )
            // If DC is selected, should tethered by selected too?
            Toggle(isOn: $filtersViewModel.chargerData.tetheredCable) {
                Text("Tethered Cable")
            }
            .onChange(of: filtersViewModel.chargerData.tetheredCable) {
                tetheredChanged.toggle()
            }
        }
    }
}
