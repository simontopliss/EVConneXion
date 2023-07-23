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

    @StateObject private var vm = MapViewModel()

    // TODO: Ask for permissions to get the user's location and store in UserDefaults
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var mapSelection: MKMapItem?
//    @State private var cameraHeight: CLLocationDistance = 5000 // Distance in metres

    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {

            Annotation("My location", coordinate: .userLocation) {
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

            ForEach(chargePointViewModel.chargeDevices) { chargeDevice in
                if let chargeDeviceCoordinate = vm.coordinateFor(chargeDevice.chargeDeviceLocation) {
                    let markerName = chargePointViewModel.displayNameFor(network: chargeDevice.attribution)

                    Marker(
                        markerName,
                        systemImage: Symbols.evChargerName,
                        coordinate: chargeDeviceCoordinate
                    )
                    .tint(Color.accentColor)
                }
            }
        }
        .mapControls {
            MapCompass()
            MapPitchButton()
            MapUserLocationButton()
        }
    }
}

#Preview {
    MapView()
        .environmentObject(ChargePointViewModel())
        .environmentObject(NavigationRouter())
}
