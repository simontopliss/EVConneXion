//
//  LocationManager.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 23/07/2023.
//

import CoreLocation
import MapKit
import SwiftUI

final class LocationManager: NSObject, ObservableObject {

    @Published var region: MKCoordinateRegion = LocationManager.defaultRegion
    @Published var cameraPosition: MapCameraPosition = .region(LocationManager.defaultRegion)

    let locationManager = CLLocationManager()

    @Published var userLocation = CLLocationCoordinate2D(latitude: 51.503351, longitude: -0.119623) // London Eye

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
}

extension LocationManager {

    static var defaultLocation: CLLocationCoordinate2D {
        return .init(latitude: 51.503351, longitude: -0.119623) // London Eye
    }

    static var defaultRegion: MKCoordinateRegion {
        .init(
            center: defaultLocation,
            latitudinalMeters: .cameraHeight,
            longitudinalMeters: .cameraHeight
        )
    }
}

extension LocationManager: CLLocationManagerDelegate {

    private func checkAuthorization() {
        // print(#function)

        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted.")
            case .denied:
                print("Your have denied app to access location services.")
            case .authorizedAlways, .authorizedWhenInUse:
                guard let location = locationManager.location else { return }
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
                )
            @unknown default:
                break
        }

    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // print(#function)
        checkAuthorization()
    }

    // Required delegate conformance
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // print(#function)

        guard let location = locations.last else { return }

        DispatchQueue.main.async { [weak self] in
            self?.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
            )
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print(#function)
        print(String(describing: error))
    }

}

// MARK: - Charge Device Locations

extension LocationManager {

    func coordinateFor(_ chargeDeviceLocation: ChargeDeviceLocation) -> CLLocationCoordinate2D? {
        guard let latitude = Double(chargeDeviceLocation.latitude),
              let longitude = Double(chargeDeviceLocation.longitude)
        else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func regionFor(_ chargeDeviceLocation: ChargeDeviceLocation) -> MKCoordinateRegion? {
        guard let locationCoordinate = coordinateFor(chargeDeviceLocation) else { return nil }

        let deviceLocation = MKCoordinateRegion(
            center: locationCoordinate,
            latitudinalMeters: .cameraHeight,
            longitudinalMeters: .cameraHeight
        )

        return deviceLocation
    }
}

extension CLLocationDistance {
    static let cameraHeight: CLLocationDistance = 2500
}

extension CLLocationCoordinate2D {

    /// Returns the distance between two coordinates in meters.
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }

}
