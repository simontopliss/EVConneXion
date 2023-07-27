//
//  ChargePointRow.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 14/07/2023.
//

import MapKit
import SwiftUI

struct ChargePointRow: View {

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var vm: ChargePointViewModel
    @EnvironmentObject private var locationManager: LocationManager

    var chargeDevice: ChargeDevice
    var address: Address {
        vm.createAddress(chargeDevice: chargeDevice)
    }
    var connectorGraphicsAndCounts: [ConnectorGraphic] {
        vm.graphicsAndCountsFor(connectors: chargeDevice.connector)
    }

    private let inset = 12.0

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(chargeDevice.chargeDeviceName.trim())
                    .font(.title2.leading(.tight))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)

                Spacer()

                Text(
                    vm.getFormattedDistance(
                        distance: chargeDevice.chargeDeviceLocation.distanceFromUser,
                        unit: vm.units
                    )
                )
                .font(.subheadline)
                .fontWeight(.semibold)
                .fontWidth(.condensed)
                .foregroundStyle(.white)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(Color.accentColor, in: Capsule())
            }
            .padding(EdgeInsets(top: inset, leading: inset, bottom: 0, trailing: inset))

            Text("Ref: \(chargeDevice.chargeDeviceRef.trim())")
                .font(.caption)
                .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))

            Text(vm.separate(deviceNetworks: chargeDevice.deviceNetworks, by: ",\n"))
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))

            Text(address.singleLineAddress)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))

            HStack {
                // Get the connector types and add a count next to the graphic
                ForEach(connectorGraphicsAndCounts) { connector in
                    HStack {
                        Image(connector.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 22)
                            .shadow(color: .secondary, radius: 3.0)

                        Text("\(connector.count)")
                            .font(.footnote)
                            .monospacedDigit()

                    }
                    .padding(.trailing, 6)
                }
            }
            .padding(EdgeInsets(top: 0, leading: inset, bottom: inset, trailing: inset))
        }
        .foregroundColor(Colors.textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Colors.listRowColor, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ChargePointRow(
        chargeDevice: ChargePointData.mockChargeDevice
    )
    .environmentObject(ChargePointViewModel())
    .environmentObject(LocationManager())
    .background(Colors.backgroundColor)
    .padding()
}
