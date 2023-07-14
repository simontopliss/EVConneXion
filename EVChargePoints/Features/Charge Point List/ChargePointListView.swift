//
//  ChargePointListView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

struct ChargePointListView: View {

    @EnvironmentObject private var vm: ChargePointViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 6) {
                ForEach(vm.chargeDevices) { chargeDevice in
                    ChargePointRow(vm: vm, chargeDevice: chargeDevice)
                }
            }
            .padding()
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
