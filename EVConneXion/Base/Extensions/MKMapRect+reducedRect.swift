//
//  MKMapRect+reducedRect.swift
//  EVConneXion
//
//  Created by Simon Topliss on 13/08/2023.
//

import MapKit

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
