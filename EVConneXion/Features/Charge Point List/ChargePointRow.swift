//
//  ChargePointRow.swift
//  EVConneXion
//
//  Created by Simon Topliss on 14/07/2023.
//

import MapKit
import SwiftUI

struct ChargePointRow: View {

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var dataManager: DataManager

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
                chargeDeviceName
                Spacer()
                distanceCapsule
            }
            .padding(EdgeInsets(top: inset, leading: inset, bottom: 0, trailing: inset))

            ref
            networks
            location
            connectors
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
    .environmentObject(LocationManager.shared)
    .background(AppColors.backgroundColor)
    .padding()
}

extension ChargePointRow {
    var distanceCapsule: some View {
        Text(
            dataManager.getFormattedDistance(
                distance: chargeDevice.deviceMapItem.distanceFromUser(
                    userLocation: LocationManager.shared.userLocation
                ),
                unit: dataManager.userSettings.unitSetting
            )
        )
        .font(.subheadline)
        .fontWeight(.semibold)
        .fontWidth(.condensed)
        .foregroundStyle(colorScheme == .dark ? .black : .white)
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
        .background(Color.accentColor, in: Capsule())
    }

    var chargeDeviceName: some View {
        Text(chargeDevice.chargeDeviceName.trim())
            .font(.title2.leading(.tight))
            .fontWeight(.semibold)
            .multilineTextAlignment(.leading)
    }

    var ref: some View {
        Text("Ref: \(chargeDevice.chargeDeviceRef.trim())")
            .font(.caption)
            .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))
            .foregroundStyle(.secondary)
    }

    var networks: some View {
        Text(chargeDevice.deviceNetworks.joined(separator: ",\n"))
            .font(.subheadline)
            .fontWeight(.semibold)
            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))
    }

    var location: some View {
        Text(chargeDevice.chargeDeviceLocation.singleLineAddress)
            .font(.caption)
            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset))
            .foregroundStyle(.secondary)
    }

    var connectors: some View {
        HStack {
            // Get the connector types and add a count next to the graphic
            ForEach(connectorGraphicsAndCounts) { connector in
                HStack {
                    Image(connector.graphicName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 22)
                        .foregroundStyle(.accent)

                    Text("\(connector.count)")
                        .font(.footnote)
                        .monospacedDigit()

                }
                .padding(.trailing, 6)
            }
        }
        .padding(EdgeInsets(top: 0, leading: inset, bottom: inset, trailing: inset))
    }
}
