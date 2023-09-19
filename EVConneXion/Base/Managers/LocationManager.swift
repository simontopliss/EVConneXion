//
//  LocationManager.swift
//  EVConneXion
//
//  Created by Simon Topliss on 23/07/2023.
//

import MapKit
import SwiftUI

// MARK: - Location Manager

final class LocationManager: NSObject, ObservableObject {

    let locationManager = CLLocationManager()
    static let shared = LocationManager()

    @Published var region: MKCoordinateRegion = LocationManager.defaultRegion
    @Published var cameraPosition: MapCameraPosition = .userLocation(fallback: .region(LocationManager.defaultRegion))
    @Published var error: LocationError? = nil
    
    var userLocation: CLLocationCoordinate2D {
        // print(region.center)
        return region.center
    }

    override private init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        // checkAuthorization()
    }

    func distanceFromUser(coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        return coordinate.distance(to: userLocation)
    }
}

// MARK: - Default Location and Region

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

enum LocationError: LocalizedError {

    case authorizationDenied
    case authorizationRestricted
    case unknownLocation
    case accessDenied
    case network
    case operationFailed

    var errorDescription: String? {
        switch self {
            case .authorizationDenied: "You have denied app to access location services."
            case .authorizationRestricted: "Your location access is restricted."
            case .unknownLocation: "Unknown location."
            case .accessDenied: "Access denied."
            case .network: "Network failed."
            case .operationFailed: "Operation failed."
        }
    }
}

// MARK: - Request User Location

extension LocationManager: CLLocationManagerDelegate {

    private func checkAuthorization() {
        // print(#function)
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                error = .authorizationRestricted
            case .denied:
                error = .authorizationDenied
            case .authorizedAlways, .authorizedWhenInUse:
                guard let location = locationManager.location else { return }
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: .deltaDegrees, longitudeDelta: .deltaDegrees)
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
                span: MKCoordinateSpan(latitudeDelta: .deltaDegrees, longitudeDelta: .deltaDegrees)
            )
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print(#function)
        print(String(describing: error))

        if let clError = error as? CLError {
            switch clError.code {
                case .locationUnknown:
                    self.error = .unknownLocation
                case .denied:
                    self.error = .accessDenied
                case .network:
                    self.error = .network
                default:
                    self.error = .operationFailed
            }
        }
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

// MARK: - Default Camera Height

extension CLLocationDistance {
    static let cameraHeight: CLLocationDistance = 5000
}

extension CLLocationDegrees {
    static let deltaDegrees = 0.5
}

// MARK: - Distance to Map Point

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    /// Returns the distance between two coordinates in meters.
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }
}
