//
//  MapView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import MapKit
import SwiftUI

struct MapView: View {

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var locationManager: LocationManager

    @Environment(\.dismiss) var dismiss

    /// Map Properties
    @State private var cameraPosition: MapCameraPosition = .region(LocationManager.defaultRegion)
    @State private var deviceSelected: ChargeDevice?
    @State private var viewingRegion: MKCoordinateRegion?
    @Namespace private var locationSpace

    /// Navigation Bar Properties
    @State private var showFilters = false
    @State private var showSearch = false

    /// Map Selection Detail Properties
    @State private var showDetails = false
    @State private var lookAroundScene: MKLookAroundScene?

    /// Route Properties
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: ChargeDevice?

    /// User Location Animation
    @State private var delay: Double = 0
    @State private var userLocationScale: CGFloat = 0.6
    @State private var pinScale: CGFloat = 0.75
    @State private var duration = 0.8

    /// Search Sheet
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Map(position: $cameraPosition, scope: locationSpace) {

                // UserAnnotation() // This needs changing when testing 'real' user location
                Annotation("My Location", coordinate: locationManager.userLocation) {
                    userAnnotation
                }
                .annotationTitles(.hidden)

                ForEach(dataManager.chargeDevices) { chargeDevice in

                    Annotation(chargeDevice.chargeDeviceName, coordinate: chargeDevice.deviceMapItem.coordinate) {
                        Button {
                            deviceSelected = chargeDevice
                            withAnimation(.snappy) {
                                // TODO: Move the camera up a bit to accommodate the MapDetails detent
                                cameraPosition = .region(chargeDevice.deviceMapItem.region)
                            }
                        } label: {
                            MapPinView(pinColor: networkColor(attribution: chargeDevice.attribution))
                        }
                        .scaleEffect(deviceSelected == chargeDevice ? 1.5 : 1.0, anchor: .bottom)
                    }
                    .tag(chargeDevice.id)
                }

                /// Display Route using Polyline
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 7)
                }
            }
            .onMapCameraChange { context in
                viewingRegion = context.region
            }
            .overlay(alignment: .bottomTrailing) {
                mapControls()
            }
            .mapScope(locationSpace)
            .navigationTitle("Charge Device Locations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.snappy) {
                            showDetails = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.snappy) {
                                showSearch.toggle()
                            }
                        }
                    } label: {
                        Symbols.searchSymbol
                    }
                }
            }
            .sheet(isPresented: $showSearch, onDismiss: {
                withAnimation(.snappy) {
                    showDetails = false
                }
            }, content: {
                RecentSearchesView(showSheet: $showSearch)
                    .presentationDetents([.height(300)])
                    .presentationBackgroundInteraction(
                        .enabled(upThrough: .height(300))
                    )
                    .presentationCornerRadius(25)
                    .interactiveDismissDisabled(true)
            })
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
                    endRoute()
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
        .searchable(
            text: $searchText,
            placement: .toolbar,
            prompt: "Enter postcode, town or city…"
        )
        .navigationDestination(for: Route.self) { $0 }
        .onChange(of: deviceSelected) { _, newValue in
            // TODO: Animate map pin when selected

            /// Displaying Details about the Selected Place
            showDetails = newValue != nil
            /// Fetching Look Around Preview, when ever selection Changes
            fetchLookAroundPreview()
        }
    }
}

#Preview {
    MapView()
        .environmentObject(DataManager())
        .environmentObject(NavigationRouter())
        .environmentObject(LocationManager())
}

extension MapView {

    var userAnnotation: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundStyle(colorScheme == .dark ? .pink.opacity(0.50) : .pink.opacity(0.25))

            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)

            Circle()
                .frame(width: 12, height: 12)
                .foregroundStyle(.pink)
        }
        .scaleEffect(userLocationScale)
        .animation(
            Animation.easeInOut(duration: duration)
                .repeatForever()
                .delay(delay),
            value: userLocationScale
        )
        .onAppear {
            withAnimation {
                self.userLocationScale = 1
            }
        }
    }

    func networkColor(attribution: String) -> Color {
        dataManager.networkColorFor(network: attribution) ?? Color.accentColor
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

extension MapView {

    func mapControls() -> some View {
        VStack(spacing: 15) {
            MapCompass(scope: locationSpace)
            MapPitchToggle(scope: locationSpace)
            /// This will work only when the user gave location access
            MapUserLocationButton(scope: locationSpace)
            /// This will goes to the defined user region
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
}

extension MapView {

    /// Map Details View
    @ViewBuilder
    func mapDetails() -> some View {
        VStack(spacing: 15) {
            ZStack {
                if lookAroundScene == nil {
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
                        deviceSelected = nil
                    }
                }, label: {
                        XmarkButtonView()
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
}

extension MapView {

    // @ViewBuilder
    func endRoute() -> some View {
        Button("End Route") {
            /// Closing The Route and Setting the Selection
            withAnimation(.snappy) {
                routeDisplaying = false
                showDetails = true
                deviceSelected = routeDestination
                routeDestination = nil
                route = nil
                if let coordinate = deviceSelected?.deviceMapItem.coordinate {
                    cameraPosition = .region(
                        .init(
                            center: coordinate,
                            latitudinalMeters: .cameraHeight,
                            longitudinalMeters: .cameraHeight
                        )
                    )
                }
            }
        }
    }
}

extension MapView {

    /// Fetching Location Preview
    func fetchLookAroundPreview() {
        if let deviceSelected {
            /// Clearing Old One
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(
                    coordinate: deviceSelected.deviceMapItem.coordinate
                )
                lookAroundScene = try? await request.scene
            }
        }
    }

    /// Fetching Route
    func fetchRoute() {
        if let deviceSelected {
            let request = MKDirections.Request()
            request.source = .init(
                placemark: .init(coordinate: locationManager.userLocation)
            )
            request.destination = deviceSelected.deviceMapItem.mapItem

            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                /// Saving Route Destination
                routeDestination = deviceSelected

                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                }
            }
        }
    }
}
