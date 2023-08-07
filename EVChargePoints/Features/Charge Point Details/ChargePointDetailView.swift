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
    }
}

#Preview {
    NavigationStack {
        ChargePointDetailView(
            chargeDevice: ChargePointData.mockChargeDevice
        )
    }
    .environmentObject(ChargePointViewModel())
}

struct FormText: View {
    let text: String

    var body: some View {
        Text(LocalizedStringKey(text.trim()))
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .foregroundStyle(AppColors.textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FormLabel: View {
    let label: String

    var body: some View {
        VStack {
            Text(label)
                .font(.subheadline.leading(.tight))
                .multilineTextAlignment(.leading)
                .frame(width: 90, alignment: .leading)
            .foregroundStyle(.secondary)
        }
    }
}
