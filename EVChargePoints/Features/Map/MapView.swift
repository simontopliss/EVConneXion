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

    /// Map Properties
    //let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
    @State private var cameraPosition: MapCameraPosition = .region(LocationManager.defaultRegion)
    @State private var deviceSelection: ChargeDevice?
    @State private var viewingRegion: MKCoordinateRegion?
    @Namespace private var locationSpace

    /// Map Selection Detail Properties
    @State private var showDetails = false
    @State private var lookAroundScene: MKLookAroundScene?

    /// Route Properties
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: ChargeDevice?

    /// User Location Animation
    @State private var delay: Double = 0
    @State private var scale: CGFloat = 0.5
    @State private var duration = 0.8

    var body: some View {

        // interactionModes: .all,
        NavigationStack {
            Map(position: $cameraPosition, scope: locationSpace) {

                // UserAnnotation() // This needs changing when testing 'real' user location
                Annotation("My Location", coordinate: mapViewModel.userLocation) {
                    userAnnotation
                }
                .annotationTitles(.hidden)

                ForEach(chargePointViewModel.chargeDevices) { chargeDevice in

                    Annotation(chargeDevice.chargeDeviceName, coordinate: chargeDevice.deviceMapItem.coordinate) {
                        Button {
                            deviceSelection = chargeDevice
                            withAnimation(.snappy) {
                                // TODO: Move the camera up a bit to accommodate the MapDetails detent
                                cameraPosition = .region(chargeDevice.deviceMapItem.region)
                            }
                        } label: {
                            MapPinView(pinColor: networkColor(attribution: chargeDevice.attribution))
                        }
                    }
                    .tag(chargeDevice.id)
                }

                /// Display Route using Polyline
                if let route {
                    MapPolyline(route.polyline)
                        /// Applying Bigger Stroke
                        .stroke(.blue, lineWidth: 7)
                }
            }
            .onMapCameraChange { context in
                viewingRegion = context.region
            }
            .overlay(alignment: .bottomTrailing) {
                VStack(spacing: 15) {
                    MapCompass(scope: locationSpace)
                    MapPitchToggle(scope: locationSpace)
                    /// As this will work only when the User Gave Location Access
                    MapUserLocationButton(scope: locationSpace)
                    /// This will Goes to the Defined User Region
                    Button {
                        withAnimation(.smooth) {
                            cameraPosition = .region(LocationManager.defaultRegion)
                        }
                    } label: {
                        Image(systemName: "mappin")
                            .font(.title3)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .buttonBorderShape(.circle)
                .padding()
            }
            .mapScope(locationSpace)
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .sheet(isPresented: $showDetails, onDismiss: {
                withAnimation(.snappy) {
                    /// Zooming Region
                    if let boundingRect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(boundingRect.reducedRect(0.45))
                    }
                }
            }, content: {
                mapDetails()
                    .presentationDetents([.height(300)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                    .presentationCornerRadius(25)
                    .interactiveDismissDisabled(true)
            })
            .safeAreaInset(edge: .bottom) {
                if routeDisplaying {
                    Button("End Route") {
                        /// Closing The Route and Setting the Selection
                        withAnimation(.snappy) {
                            routeDisplaying = false
                            showDetails = true
                            deviceSelection = routeDestination
                            routeDestination = nil
                            route = nil
                            if let coordinate = deviceSelection?.deviceMapItem.coordinate {
                                cameraPosition = .region(
                                    .init(
                                        center: coordinate,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000
                                    )
                                )
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .padding(.vertical, 12)
                    .background(.red.gradient, in: .rect(cornerRadius: 15))
                    .padding()
                    .background(.ultraThinMaterial)
                }
            }
        }
        .onChange(of: deviceSelection) { _, newValue in
            /// Displaying Details about the Selected Place
            showDetails = newValue != nil
            /// Fetching Look Around Preview, when ever selection Changes
            fetchLookAroundPreview()
        }
    }

    /// Map Details View
    @ViewBuilder
    func mapDetails() -> some View {
        VStack(spacing: 15) {
            ZStack {
                /// New Look Around API
                if lookAroundScene == nil {
                    /// New Empty View API
                    ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                } else {
                    LookAroundPreview(scene: $lookAroundScene)
                }
            }
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 15))
            /// Close Button
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    /// Closing View
                    showDetails = false
                    withAnimation(.snappy) {
                        deviceSelection = nil
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.black)
                        .background(.white, in: .circle)
                })
                .padding(10)
            }

            /// Direction's Button
            Button("Get Directions", action: fetchRoute)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
                .background(.blue.gradient, in: .rect(cornerRadius: 15))
        }
        .padding(15)
    }

    /// Fetching Location Preview
    func fetchLookAroundPreview() {
        if let deviceSelection {
            /// Clearing Old One
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(
                    coordinate: deviceSelection.deviceMapItem.coordinate
                )
                lookAroundScene = try? await request.scene
            }
        }
    }

    /// Fetching Route
    func fetchRoute() {
        if let deviceSelection {
            let request = MKDirections.Request()
            request.source = .init(
                placemark: .init(coordinate: locationManager.userLocation)
            )
            request.destination = deviceSelection.deviceMapItem.mapItem

            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                /// Saving Route Destination
                routeDestination = deviceSelection

                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                }
            }
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

extension MKMapRect {
    func reducedRect(_ fraction: CGFloat = 0.35) -> MKMapRect {
        var regionRect = self

        let wPadding = regionRect.size.width * fraction
        let hPadding = regionRect.size.height * fraction

        regionRect.size.width += wPadding
        regionRect.size.height += hPadding

        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2

        return regionRect
    }
}
