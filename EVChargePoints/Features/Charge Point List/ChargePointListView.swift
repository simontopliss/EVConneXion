//
//  ChargePointListView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

struct ChargePointListView: View {

    @EnvironmentObject private var vm: ChargePointViewModel
    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var locationManager: LocationManager

    // TODO: Use NavigationSplitView for iPad support

    init() {
        //vm.lo
    }

    var body: some View {
        NavigationStack(path: $routerManager.routes) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    ForEach(vm.chargeDevices) { chargeDevice in
                        NavigationLink(value: Route.chargePointDetail(chargeDevice: chargeDevice)) {
                            ChargePointRow(chargeDevice: chargeDevice)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.background)
            .navigationTitle("Charge Devices")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Route.self) { $0 }
            .buttonStyle(PlainButtonStyle())
            // .task {
            //      await vm.fetchChargeDevices(requestType: .postcode("EC3A 7BR"))
            //      await vm.fetchChargeDevices(requestType: .postTown("South Shields"))
            // }
        }
    }
}

#Preview {
    ChargePointListView()
        .environmentObject(ChargePointViewModel())
        .environmentObject(NavigationRouter())
        .environmentObject(LocationManager())
}
