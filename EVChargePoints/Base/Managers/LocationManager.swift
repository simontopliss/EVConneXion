//
//  LocationManager.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 23/07/2023.
//

import CoreLocation
import Foundation
import MapKit

final class LocationManager: NSObject, ObservableObject {

    @Published var region: MKCoordinateRegion = LocationManager.defaultRegion
    let locationManager = CLLocationManager()

    // TODO: Store in UserDefaults
    @Published var cameraHeight: CLLocationDistance = 2500 // Distance in metres

//    var route: MKRoute!
    var userLocation = CLLocationCoordinate2D(latitude: 51.503351, longitude: -0.119623) // London Eye
    var userMapItem: MKMapItem?

    //let miles = Measurement(value: meters, unit: UnitLength.meters).converted(to: UnitLength.miles).value

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
        print(#function)
        print(String(describing: error))
    }

}

// MARK: - Charge Device Locations

extension LocationManager {

    func coordinateFor(_ chargeDeviceLocation: ChargeDeviceLocation) -> CLLocationCoordinate2D? {
        guard let latitude = Double(chargeDeviceLocation.latitude),
              let longitude = Double(chargeDeviceLocation.longitude) else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func regionFor(_ chargeDeviceLocation: ChargeDeviceLocation) -> MKCoordinateRegion? {

        guard let locationCoordinate = coordinateFor(chargeDeviceLocation) else { return nil }

        let deviceLocation = MKCoordinateRegion(
            center: locationCoordinate,
            latitudinalMeters: cameraHeight,
            longitudinalMeters: cameraHeight
        )

        return deviceLocation
    }

//    func distanceToAllLocations(chargeDevices: [ChargeDevice]) {
//        self.userMapItem = MKMapItem(placemark: .init(coordinate: userLocation))
//
//        for chargeDevice in chargeDevices {
//
//            if let coordinate = coordinateFor(chargeDevice.chargeDeviceLocation) {
//                let mapItem =  MKMapItem(placemark: .init(coordinate: coordinate))
//
//                getDistanceToDevice(
//                    srcMapItem: userMapItem!,
//                    destMapItem: mapItem
//                )
//
//                if let route {
//                    let location = Location(
//                        id: UUID(),
//                        chargeDeviceID: chargeDevice.chargeDeviceID,
//                        coordinate: coordinate,
//                        distanceFromUser: route.distance
//                    )
//                }
//            }
//        }
//    }

//    func getDistanceToDevice(srcMapItem: MKMapItem, destMapItem: MKMapItem) {
//        let request = MKDirections.Request() // create a direction request object
//        request.source = srcMapItem // this is the source location mapItem object
//        request.destination = destMapItem // this is the destination location mapItem object
//        request.transportType = MKDirectionsTransportType.automobile // define the transportation method
//
//        Task {
//            let result = try? await MKDirections(request: request).calculate()
//            route = result?.routes.first!
//        }
//    }
}

extension CLLocationCoordinate2D {

    /// Returns the distance between two coordinates in meters.
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }

}
