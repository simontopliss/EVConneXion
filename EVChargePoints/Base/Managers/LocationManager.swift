//
//  LocationManager.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 23/07/2023.
//

import CoreLocation
import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject {

    @Published var region: MKCoordinateRegion = LocationManager.defaultRegion
    let locationManager = CLLocationManager()
//    var route: MKRoute!

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
        return .init(latitude: 51.503351, longitude: -0.119623)
    }

    static var defaultRegion: MKCoordinateRegion {
        .init(
            center: self.defaultLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
    }
}

extension LocationManager: CLLocationManagerDelegate {

    private func checkAuthorization() {
        print(#function)

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
        print(#function)
        checkAuthorization()
    }

    // Required delegate conformance
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)

        guard let location = locations.last else { return }

        DispatchQueue.main.async { [weak self] in
            self?.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
            )
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(String(describing: error))
    }

}

extension LocationManager {

    static func getDistanceToDestination(srcMapItem: MKMapItem, destMapItem: MKMapItem) -> MKRoute? {
        let request = MKDirections.Request() //create a direction request object
        request.source = srcMapItem //this is the source location mapItem object
        request.destination = destMapItem //this is the destination location mapItem object
        request.transportType = MKDirectionsTransportType.automobile //define the transportation method

        Task {
            let result = try? await MKDirections(request: request).calculate()
            return result?.routes.first
        }

        return nil
    }
}
