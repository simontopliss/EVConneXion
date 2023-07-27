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

    // Map Properties
    @State private var cameraPosition: MapCameraPosition = .region(LocationManager.defaultRegion)
    @State private var mapSelection: MKMapItem?
    @State private var deviceSelection: ChargeDevice?
    @Namespace private var locationSpace

    @State private var showDetails = false
    @State private var getDirections = false

    // User Location Animation
    @State private var delay: Double = 0
    @State private var scale: CGFloat = 0.5
    @State private var duration = 0.8

    var body: some View {

        // interactionModes: .all, 
        Map(position: $cameraPosition, selection: $mapSelection, scope: locationSpace) {

            // UserAnnotation() // This needs changing when testing 'real' user location
            Annotation("My Location", coordinate: mapViewModel.userLocation) {
                userAnnotation
            }

            ForEach(chargePointViewModel.chargeDevices) { chargeDevice in

                let mapItem = chargeDevice.deviceMapMarker.mapItem
                let placemark = mapItem.placemark

                Marker(
                    markerName(attribution: chargeDevice.attribution),
                    systemImage: Symbols.evChargerName,
                    coordinate: placemark.coordinate
                )
                .tag(chargeDevice.id)
                .tint(networkColor(attribution: chargeDevice.attribution))
            }
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            showDetails = newValue != nil
            let _ = print(mapSelection?.name)
        }
        .sheet(isPresented: $showDetails) {
            if let deviceSelection {
                LocationDetailsView(
                    mapSelection: $mapSelection,
                    chargeDevice: deviceSelection,
                    show: $showDetails,
                    getDirections: $getDirections
                )
            }
        }
        .presentationDetents([.height(340)])
        .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
        .presentationCornerRadius(12)
        .padding()
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
