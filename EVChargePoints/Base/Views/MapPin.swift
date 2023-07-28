//
//  MapPin.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 28/07/2023.
//

import SwiftUI

struct MapPin: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        path.move(to: CGPoint(x: width, y: 0.31438 * height))
        path.addCurve(
            to: CGPoint(x: 0.5 * width, y: height),
            control1: CGPoint(x: width, y: 0.59375 * height),
            control2: CGPoint(x: 0.5945 * width, y: height)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: 0.31438 * height),
            control1: CGPoint(x: 0.41175 * width, y: height),
            control2: CGPoint(x: 0, y: 0.67688 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.5 * width, y: 0),
            control1: CGPoint(x: 0, y: 0.14078 * height),
            control2: CGPoint(x: 0.22375 * width, y: 0)
        )
        path.addCurve(
            to: CGPoint(x: width, y: 0.31438 * height),
            control1: CGPoint(x: 0.77625 * width, y: 0),
            control2: CGPoint(x: width, y: 0.14078 * height)
        )
        path.closeSubpath()

        return path
    }
}

#Preview {
    MapPin()
        .frame(width: 18.75, height: 30)
}
