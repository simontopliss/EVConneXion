//
//  MapView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import MapKit
import SwiftUI

struct MapView: View {

    @EnvironmentObject private var chargePointViewModel: ChargePointViewModel
    @EnvironmentObject private var routerManager: NavigationRouter

    @StateObject private var mapViewModel = MapViewModel()

    @State private var cameraPosition: MapCameraPosition = .region(LocationManager.defaultRegion)
    @State private var mapSelection: MKMapItem?

    @Namespace private var locationSpace

    var body: some View {

        Map(position: $cameraPosition, selection: $mapSelection, scope: locationSpace) {

            Annotation("My location", coordinate: mapViewModel.userLocation) {
                userLocation
            }

            ForEach(chargePointViewModel.chargeDevices) { chargeDevice in
                if let chargeDeviceCoordinate = mapViewModel.coordinateFor(chargeDevice.chargeDeviceLocation) {
                    Marker(
                        markerName(attribution: chargeDevice.attribution),
                        systemImage: Symbols.evChargerName,
                        coordinate: chargeDeviceCoordinate
                    )
                    .tint(networkColor(attribution: chargeDevice.attribution))
                }
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
}

#Preview {
    MapView()
        .environmentObject(ChargePointViewModel())
        .environmentObject(NavigationRouter())
}

extension MapView {

    var userLocation: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundStyle(.pink.opacity(0.25))

            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)

            Circle()
                .frame(width: 12, height: 12)
                .foregroundColor(.pink)
        }
    }

    func markerName(attribution: String) -> String {
        chargePointViewModel.displayNameFor(network: attribution)
    }

    func networkColor(attribution: String) -> Color {
        chargePointViewModel.networkColorFor(network: attribution) ?? Color.accentColor
    }
}
