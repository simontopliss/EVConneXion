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

    let vm: ChargePointViewModel
    let chargeDevice: ChargeDevice
    var address: Address {
        vm.createAddress(chargeDevice: chargeDevice)
    }

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

            withAnimation {
                selectedView == .information
                ? AnyView(ChargePointInfoView(vm: vm, chargeDevice: chargeDevice))
                : AnyView(ChargePointDevicesView(vm: vm, chargeDevice: chargeDevice))
            }
            Spacer()
        }
        .navigationTitle(chargeDevice.chargeDeviceName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChargePointDetailView(
        vm: ChargePointViewModel(),
        chargeDevice: ChargePointData.mockChargeDevice
    )
    // .colorScheme(.dark)
    .embedInNavigation()
    .environmentObject(ChargePointViewModel())
}

struct FormText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .foregroundColor(Colors.textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FormLabel: View {
    let label: String

    var body: some View {
        VStack {
            Text(label)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .frame(width: 90, alignment: .leading)
            .foregroundColor(.secondary)
        }
    }
}
