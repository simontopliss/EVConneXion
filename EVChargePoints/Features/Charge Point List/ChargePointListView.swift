//
//  ChargePointListView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

struct ChargePointListView: View {

    @StateObject private var vm = ChargePointViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
//            await vm.fetchChargeDevices(requestType: .postcode("DE7 8LN"))
            await vm.fetchChargeDevices(requestType: .postTown("South Shields"))
        }
    }
}

#Preview {
    ChargePointListView()
}
