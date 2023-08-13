//
//  AnnotationButtonView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 13/08/2023.
//

import MapKit
import SwiftUI

struct AnnotationButtonView: View {

    @EnvironmentObject private var dataManager: DataManager

    var chargeDevice: ChargeDevice
    @Binding var cameraPosition: MapCameraPosition
    @Binding var deviceSelected: ChargeDevice?

    var body: some View {
        Button {
            deviceSelected = chargeDevice
            withAnimation(.snappy) {
                // TODO: Move the camera up a bit to accommodate the MapDetails detent
                cameraPosition = .region(chargeDevice.deviceMapItem.region)
            }
        } label: {
            MapPinView(pinColor: dataManager.networkColor(attribution: chargeDevice.attribution))
        }
        .scaleEffect(deviceSelected == chargeDevice ? 1.5 : 1.0, anchor: .bottom)
        .animation(
            .bouncy(duration: 0.5, extraBounce: 0.25),
            value: deviceSelected == chargeDevice
        )
    }
}

#Preview {
    AnnotationButtonView(
        chargeDevice: ChargePointData.mockChargeDevice,
        cameraPosition: .constant(MapCameraPosition.region(LocationManager.defaultRegion)),
        deviceSelected: .constant(ChargePointData.mockChargeDevice)
    )
    .environmentObject(DataManager())
    .environmentObject(LocationManager())
}
