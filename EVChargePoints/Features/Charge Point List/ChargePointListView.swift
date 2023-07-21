//
//  ChargePointListView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import Observation
import SwiftUI

struct ChargePointListView: View {

    @Environment(ChargePointViewModel.self) private var vm
    @Environment(NavigationRouter.self) private var routerManager

    // TODO: Move this to Main and manage all paths from there
    // Paths must conform to `Hashable`
    // Use NavigationSplitView for iPad support
    // @State private var path: NavigationPath = .init()

    var body: some View {

        @Bindable var routerManagerBindable = routerManager

        NavigationStack(path: $routerManagerBindable.routes) {
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
        .environment(ChargePointViewModel())
        .environment(NavigationRouter())
}
