//
//  ChargePointListView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

struct ChargePointListView: View {

    @EnvironmentObject private var vm: ChargePointViewModel
    @State private var path: NavigationPath = .init()

    var body: some View {
        NavigationStack() {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(vm.chargeDevices) { chargeDevice in
                        NavigationLink(value: chargeDevice) {
                            ChargePointRow(vm: vm, chargeDevice: chargeDevice)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Charge Devices")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: ChargeDevice.self) { chargeDevice in
                ChargePointDetailView(vm: vm, chargeDevice: chargeDevice)
            }
            .buttonStyle(PlainButtonStyle())
        }
//        .task {
//            await vm.fetchChargeDevices(requestType: .postcode("EC3A 7BR"))
            // await vm.fetchChargeDevices(requestType: .postTown("South Shields"))
//        }
    }
}

#Preview {
    ChargePointListView()
        .environmentObject(ChargePointViewModel())
}
