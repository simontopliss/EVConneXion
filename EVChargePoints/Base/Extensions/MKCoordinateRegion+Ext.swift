import Foundation
import MapKit

extension MKCoordinateRegion {

    static var defaultRegion: MKCoordinateRegion {
        .init(
            center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.03121860),
            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
    }
}
