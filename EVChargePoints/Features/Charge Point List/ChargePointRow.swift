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
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var locationManager: LocationManager

    var chargeDevice: ChargeDevice

    var connectorGraphicsAndCounts: [ConnectorGraphic] {
        dataManager.graphicsAndCountsFor(
            connectors: chargeDevice.connector,
            colorScheme: colorScheme
        )
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
                    dataManager.getFormattedDistance(
                        distance: chargeDevice.deviceMapItem.distanceFromUser,
                        unit: dataManager.units
                    )
                )
                .font(.subheadline)
                .fontWeight(.semibold)
                .fontWidth(.condensed)
                .foregroundStyle(.white)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(AppColors.darkGreen, in: Capsule())
            }
            .padding(EdgeInsets(top: inset, leading: inset, bottom: 0, trailing: inset))

            Text("Ref: \(chargeDevice.chargeDeviceRef.trim())")
                .font(.caption)
                .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))
                .foregroundStyle(.secondary)

            Text(chargeDevice.deviceNetworks.joined(separator: ",\n"))
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))

            Text(chargeDevice.chargeDeviceLocation.singleLineAddress)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))
                .foregroundStyle(.secondary)

            HStack {
                // Get the connector types and add a count next to the graphic
                ForEach(connectorGraphicsAndCounts) { connector in
                    HStack {
                        Image(connector.graphicName)
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
        .foregroundStyle(AppColors.textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.listRowColor, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ChargePointRow(
        chargeDevice: ChargePointData.mockChargeDevice
    )
    .environmentObject(DataManager())
    .environmentObject(LocationManager())
    .background(AppColors.backgroundColor)
    .padding()
}
