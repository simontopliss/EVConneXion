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
    @EnvironmentObject private var locationManager: LocationManager

    @StateObject private var mapViewModel = MapViewModel()

    @State private var cameraPosition: MapCameraPosition = .region(LocationManager.defaultRegion)
    @State private var mapSelection: MKMapItem?

    @Namespace private var locationSpace

    // User Location Animation
    @State private var delay: Double = 0
    @State private var scale: CGFloat = 0.5
    @State private var duration = 0.8

    var body: some View {

        Map(position: $cameraPosition, selection: $mapSelection, scope: locationSpace) {

            // UserAnnotation() // This needs changing when testing 'real' user location
            Annotation("My location", coordinate: mapViewModel.userLocation) {
                userAnnotation
            }

            ForEach(chargePointViewModel.chargeDevices) { chargeDevice in
                if let chargeDeviceCoordinate = locationManager.coordinateFor(chargeDevice.chargeDeviceLocation) {
                    Marker(
                        markerName(attribution: chargeDevice.attribution),
                        systemImage: Symbols.evChargerName,
                        coordinate: chargeDeviceCoordinate
                    )
                    .tint(networkColor(attribution: chargeDevice.attribution))
                }
            }
        }
        // .mapStyle(.hybrid)
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
        .environmentObject(LocationManager())
}

extension MapView {

    var userAnnotation: some View {
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
        .scaleEffect(scale)
        .animation(
            Animation.easeInOut(duration: duration)
                .repeatForever()
                .delay(delay),
            value: scale
        )
        .onAppear {
            withAnimation {
                self.scale = 1
            }
        }
    }

    func markerName(attribution: String) -> String {
        chargePointViewModel.displayNameFor(network: attribution)
    }

    func networkColor(attribution: String) -> Color {
        chargePointViewModel.networkColorFor(network: attribution) ?? Color.accentColor
    }
}
