//
//  ChargePointDetailView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct ChargePointDetailView: View {

    var vm: ChargePointViewModel
    var chargeDevice: ChargeDevice
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ChargePointDetailView(
        vm: ChargePointViewModel(),
        chargeDevice: ChargePointData.mockChargeDevice
    )
    .environmentObject(ChargePointViewModel())
}
