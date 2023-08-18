//
//  ChargerFiltersView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct ChargerFiltersView: View {

    @EnvironmentObject private var dataManager: DataManager

    @State private var methodChanged = false
    @State private var speedChanged = false
    @State private var tetheredChanged = false

    var body: some View {
        Form {
            Section("Charger") {
                Group {
                    chargingMethod
                    chargingSpeed
                    tetheredCable
                }
                .font(.headline)
                .foregroundStyle(AppColors.textColor)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    ChargerFiltersView()
        .environmentObject(DataManager())
}

extension ChargerFiltersView {

    var chargingMethod: some View {
        HStack {
            SFSymbolImageBounce(
                symbolName: dataManager.chargerData.chargeMethodsSymbol,
                toggled: $methodChanged
            )

            // TODO: I think I need to change the corresponding Method/Speed depending on what is selected.
            // E.g. If DC is selected should the speed be set to Fast at a minimum?
            Picker("Supply", selection: $dataManager.chargerData.selectedMethod) {
                ForEach(dataManager.chargerData.chargeMethods, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .onChange(of: dataManager.chargerData.selectedMethod) {
                methodChanged.toggle()
                dataManager.saveSettings(.charger)
            }
        }
    }
}

extension ChargerFiltersView {

    @ViewBuilder
    var chargingSpeed: some View {
        HStack {
            SFSymbolImageBounce(
                symbolName: dataManager.chargerData.chargeSpeedsSymbol,
                toggled: $speedChanged
            )

            Picker("Charger Speed", selection: $dataManager.chargerData.selectedSpeed) {
                ForEach(dataManager.chargerData.chargeSpeeds, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: dataManager.chargerData.selectedSpeed) {
                speedChanged.toggle()
                dataManager.saveSettings(.charger)
            }
        }

    }
}

extension ChargerFiltersView {

    var tetheredCable: some View {
        HStack {
            SFSymbolImageBounce(
                symbolName: dataManager.chargerData.tetheredCableSymbol,
                toggled: $tetheredChanged
            )

            // If DC is selected, should tethered by selected too?
            Toggle(isOn: $dataManager.chargerData.tetheredCable) {
                Text("Tethered Cable")
            }
            .onChange(of: dataManager.chargerData.tetheredCable) {
                tetheredChanged.toggle()
                dataManager.saveSettings(.charger)
            }
        }
    }
}
