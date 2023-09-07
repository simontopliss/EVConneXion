//
//  MapView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 29/06/2023.
//

import MapKit
import SwiftUI

struct MapView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isSearching) private var isSearching

    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var locationManager: LocationManager

    /// Map Properties
    @State private var deviceSelected: ChargeDevice?
    @State private var mapSelection: MKMapItem?
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

    var body: some View {
        NavigationStack {
            Map(position: $locationManager.cameraPosition, selection: $mapSelection, scope: locationSpace) {

                // UserAnnotation() // This needs changing when testing 'real' user location
                Annotation("My Location", coordinate: locationManager.userLocation) {
                    UserAnnotationView()
                }
                .annotationTitles(.hidden)

                ForEach($dataManager.filteredDevices) { chargeDevice in
                    Annotation(
                        chargeDevice.chargeDeviceName.wrappedValue,
                        coordinate: chargeDevice.deviceMapItem.coordinate.wrappedValue
                    ) {
                        AnnotationButtonView(
                            chargeDevice: chargeDevice.wrappedValue,
                            cameraPosition: $locationManager.cameraPosition,
                            deviceSelected: $deviceSelected
                        )
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
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SearchToolbarItem(showDetails: $showDetails, showSearch: $showSearch)
                }
            }
            .sheet(isPresented: $showSearch, onDismiss: {
                withAnimation(.snappy) { showDetails = false }
            }, content: {
                SearchView(showSheet: $showSearch)
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(
                        .enabled(upThrough: .medium)
                    )
                    .presentationCornerRadius(25)
                    .interactiveDismissDisabled(true)
            })
            .sheet(isPresented: $showDetails, onDismiss: {
                withAnimation(.snappy) {
                    /// Zooming Region
                    if let boundingRect = route?.polyline.boundingMapRect, routeDisplaying {
                        locationManager.cameraPosition = .rect(boundingRect.reducedRect(0.45))
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
        .navigationDestination(for: Route.self) { $0 }
        .onChange(of: deviceSelected) { _, newValue in
            /// Displaying Details about the Selected Place
            showDetails = newValue != nil
            /// Fetching Look Around Preview, when ever selection Changes
            fetchLookAroundPreview()
        }
    }

    func mapControls() -> some View {
        VStack(spacing: 15) {
            MapCompass(scope: locationSpace)
            MapPitchToggle(scope: locationSpace)
            /// This will work only when the user gave location access
            MapUserLocationButton(scope: locationSpace)
            /// This will goes to the defined user region
            Button {
                withAnimation(.smooth) {
                    //locationManager.region = dataManager.filteredDevices.first?.deviceMapItem.region ?? LocationManager.defaultRegion
                    locationManager.cameraPosition = .region(
                        dataManager.filteredDevices.first?.deviceMapItem.region ?? LocationManager.defaultRegion
                    )
                }
            } label: {
                Symbols.chargerSearchSymbol
                    .font(.title2)
                    .foregroundStyle(colorScheme == .dark ? AppColors.darkBlue : .white)
            }
            .buttonStyle(.borderedProminent)
        }
        .buttonBorderShape(.circle)
        .padding()
    }

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

    @ViewBuilder
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
                    locationManager.cameraPosition = .region(
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

    struct UserAnnotationView: View {

        @Environment(\.colorScheme) var colorScheme
        @State private var userLocationScale: CGFloat = 0.6

        var body: some View {
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
                Animation.easeInOut(duration: 0.8)
                    .repeatForever()
                    .delay(0.1),
                value: userLocationScale
            )
            .onAppear {
                withAnimation {
                    userLocationScale = 1
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(DataManager())
        .environmentObject(NavigationRouter())
        .environmentObject(LocationManager())
}

