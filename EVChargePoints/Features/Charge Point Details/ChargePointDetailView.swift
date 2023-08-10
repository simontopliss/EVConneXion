//
//  ChargePointDetailView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct ChargePointDetailView: View {

    enum SelectedView: String {
        case information = "Information"
        case devices = "Devices"
    }

    @State private var selectedView: SelectedView = .information

    let chargeDevice: ChargeDevice

    var body: some View {
        VStack {
            Picker("Selected View", selection: $selectedView) {
                Text(SelectedView.information.rawValue)
                    .tag(SelectedView.information)
                Text(SelectedView.devices.rawValue)
                    .tag(SelectedView.devices)
            }
            .pickerStyle(.segmented)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))

            if selectedView == .information {
                ChargePointInfoView(chargeDevice: chargeDevice)
            } else {
                ChargePointDevicesView(chargeDevice: chargeDevice)
            }

            Spacer()
        }
        .navigationTitle(chargeDevice.chargeDeviceName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        ChargePointDetailView(
            chargeDevice: ChargePointData.mockChargeDevice
        )
    }
    .environmentObject(DataManager())
}
