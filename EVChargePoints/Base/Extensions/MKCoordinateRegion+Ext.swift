import Foundation
import MapKit

extension MKCoordinateRegion {

    static var defaultRegion: MKCoordinateRegion {
        .init(
            center: .defaultLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
    }
}
