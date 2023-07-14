//
//  ChargePointRow.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 14/07/2023.
//

import SwiftUI

struct ChargePointRow: View {

    var vm: ChargePointViewModel
    var chargeDevice: ChargeDevice
    var address: Address {
        vm.createAddress(chargeDevice: chargeDevice)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(chargeDevice.chargeDeviceName)
                .font(.title2)

            Text("Ref: \(chargeDevice.chargeDeviceRef)")
                .font(.caption)

            Text(address.singleLineAddress)
                .font(.caption)
        }
    }
}

#Preview {
    ChargePointRow(
        vm: ChargePointViewModel(),
        chargeDevice: ChargePointData.mockChargeDevice
    )
}
