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
    var connectorGraphicsAndCounts: [ConnectorGraphic] {
        vm.getConnectorGraphicsAndCounts(connectors: chargeDevice.connector)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(chargeDevice.chargeDeviceName)
                .font(.title2)
                .fontWeight(.semibold)

            Text("Ref: \(chargeDevice.chargeDeviceRef)")
                .font(.caption)

            Text(chargeDevice.attribution)
                .font(.subheadline)
                .fontWeight(.semibold)

            Text(address.singleLineAddress)
                .font(.caption)

            HStack {
                // Get the connector types and add a count next to the graphic
                ForEach(connectorGraphicsAndCounts) { connector in
                    HStack {
                        Image(connector.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        .frame(height: 22)
                        
                        Text("\(connector.count)")
                            .font(.footnote)
                    }
                    .padding(.trailing, 6)
                }
            }
        }
        Divider()
    }
}

#Preview {
    ChargePointRow(
        vm: ChargePointViewModel(),
        chargeDevice: ChargePointData.mockChargeDevice
    )
    .padding()
}
