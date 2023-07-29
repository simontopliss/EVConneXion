//
//  PaymentSymbol.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 28/07/2023.
//

import SwiftUI

struct PaymentSymbol: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        path.move(to: CGPoint(x: 0.49978 * width, y: height))

        path.addCurve(to: CGPoint(x: width, y: 0.50022 * height), control1: CGPoint(x: 0.77353 * width, y: height), control2: CGPoint(x: width, y: 0.77353 * height))
        path.addCurve(to: CGPoint(x: 0.49945 * width, y: 0), control1: CGPoint(x: width, y: 0.22691 * height), control2: CGPoint(x: 0.77309 * width, y: 0))
        path.addCurve(to: CGPoint(x: 0, y: 0.50022 * height), control1: CGPoint(x: 0.22581 * width, y: 0), control2: CGPoint(x: 0, y: 0.22647 * height))
        path.addCurve(to: CGPoint(x: 0.49978 * width, y: height), control1: CGPoint(x: 0, y: 0.77397 * height), control2: CGPoint(x: 0.22647 * width, y: height))
        path.closeSubpath()

        path.move(to: CGPoint(x: 0.49978 * width, y: 0.92859 * height))
        path.addCurve(to: CGPoint(x: 0.07174 * width, y: 0.50022 * height), control1: CGPoint(x: 0.2625 * width, y: 0.92859 * height), control2: CGPoint(x: 0.07174 * width, y: 0.73739 * height))
        path.addCurve(to: CGPoint(x: 0.49945 * width, y: 0.07174 * height), control1: CGPoint(x: 0.07174 * width, y: 0.26305 * height), control2: CGPoint(x: 0.26218 * width, y: 0.07174 * height))
        path.addCurve(to: CGPoint(x: 0.92826 * width, y: 0.50011 * height), control1: CGPoint(x: 0.73673 * width, y: 0.07174 * height), control2: CGPoint(x: 0.92826 * width, y: 0.2625 * height))
        path.addCurve(to: CGPoint(x: 0.49989 * width, y: 0.92848 * height), control1: CGPoint(x: 0.92826 * width, y: 0.73772 * height), control2: CGPoint(x: 0.7375 * width, y: 0.92848 * height))
        path.addLine(to: CGPoint(x: 0.49978 * width, y: 0.92859 * height))
        path.closeSubpath()
        
        path.move(to: CGPoint(x: 0.32737 * width, y: 0.7634 * height))
        path.addLine(to: CGPoint(x: 0.67003 * width, y: 0.7634 * height))
        path.addCurve(to: CGPoint(x: 0.71898 * width, y: 0.71639 * height), control1: CGPoint(x: 0.69839 * width, y: 0.7634 * height), control2: CGPoint(x: 0.71898 * width, y: 0.74475 * height))
        path.addCurve(to: CGPoint(x: 0.67003 * width, y: 0.66978 * height), control1: CGPoint(x: 0.71898 * width, y: 0.68765 * height), control2: CGPoint(x: 0.69839 * width, y: 0.66978 * height))
        path.addLine(to: CGPoint(x: 0.43343 * width, y: 0.66978 * height))
        path.addLine(to: CGPoint(x: 0.43343 * width, y: 0.66667 * height))
        path.addCurve(to: CGPoint(x: 0.49132 * width, y: 0.54857 * height), control1: CGPoint(x: 0.47189 * width, y: 0.64647 * height), control2: CGPoint(x: 0.49132 * width, y: 0.60101 * height))
        path.addCurve(to: CGPoint(x: 0.48899 * width, y: 0.5171 * height), control1: CGPoint(x: 0.49132 * width, y: 0.5373 * height), control2: CGPoint(x: 0.49015 * width, y: 0.5272 * height))
        path.addLine(to: CGPoint(x: 0.6269 * width, y: 0.5171 * height))
        path.addCurve(to: CGPoint(x: 0.66031 * width, y: 0.48641 * height), control1: CGPoint(x: 0.6471 * width, y: 0.5171 * height), control2: CGPoint(x: 0.66031 * width, y: 0.50467 * height))
        path.addCurve(to: CGPoint(x: 0.6269 * width, y: 0.45572 * height), control1: CGPoint(x: 0.66031 * width, y: 0.46776 * height), control2: CGPoint(x: 0.6471 * width, y: 0.45572 * height))
        path.addLine(to: CGPoint(x: 0.475 * width, y: 0.45572 * height))
        path.addCurve(to: CGPoint(x: 0.46568 * width, y: 0.39317 * height), control1: CGPoint(x: 0.46995 * width, y: 0.43629 * height), control2: CGPoint(x: 0.46568 * width, y: 0.41648 * height))
        path.addCurve(to: CGPoint(x: 0.58028 * width, y: 0.29915 * height), control1: CGPoint(x: 0.46568 * width, y: 0.33684 * height), control2: CGPoint(x: 0.50647 * width, y: 0.29915 * height))
        path.addCurve(to: CGPoint(x: 0.66614 * width, y: 0.30731 * height), control1: CGPoint(x: 0.62341 * width, y: 0.29915 * height), control2: CGPoint(x: 0.64011 * width, y: 0.30731 * height))
        path.addCurve(to: CGPoint(x: 0.70615 * width, y: 0.26963 * height), control1: CGPoint(x: 0.68984 * width, y: 0.30731 * height), control2: CGPoint(x: 0.70615 * width, y: 0.2941 * height))
        path.addCurve(to: CGPoint(x: 0.67896 * width, y: 0.22728 * height), control1: CGPoint(x: 0.70615 * width, y: 0.25098 * height), control2: CGPoint(x: 0.69761 * width, y: 0.23738 * height))
        path.addCurve(to: CGPoint(x: 0.5628 * width, y: 0.20747 * height), control1: CGPoint(x: 0.6506 * width, y: 0.21252 * height), control2: CGPoint(x: 0.61369 * width, y: 0.20747 * height))
        path.addCurve(to: CGPoint(x: 0.35107 * width, y: 0.38113 * height), control1: CGPoint(x: 0.43071 * width, y: 0.20747 * height), control2: CGPoint(x: 0.35107 * width, y: 0.2774 * height))
        path.addCurve(to: CGPoint(x: 0.36195 * width, y: 0.45572 * height), control1: CGPoint(x: 0.35107 * width, y: 0.40599 * height), control2: CGPoint(x: 0.35612 * width, y: 0.43124 * height))
        path.addLine(to: CGPoint(x: 0.3064 * width, y: 0.45572 * height))
        path.addCurve(to: CGPoint(x: 0.27299 * width, y: 0.48641 * height), control1: CGPoint(x: 0.28619 * width, y: 0.45572 * height), control2: CGPoint(x: 0.27299 * width, y: 0.46776 * height))
        path.addCurve(to: CGPoint(x: 0.3064 * width, y: 0.5171 * height), control1: CGPoint(x: 0.27299 * width, y: 0.50467 * height), control2: CGPoint(x: 0.28619 * width, y: 0.5171 * height))
        path.addLine(to: CGPoint(x: 0.37632 * width, y: 0.5171 * height))
        path.addCurve(to: CGPoint(x: 0.38021 * width, y: 0.55362 * height), control1: CGPoint(x: 0.37866 * width, y: 0.52992 * height), control2: CGPoint(x: 0.38021 * width, y: 0.54196 * height))
        path.addCurve(to: CGPoint(x: 0.31805 * width, y: 0.66317 * height), control1: CGPoint(x: 0.38021 * width, y: 0.61034 * height), control2: CGPoint(x: 0.34991 * width, y: 0.64724 * height))
        path.addCurve(to: CGPoint(x: 0.27959 * width, y: 0.71639 * height), control1: CGPoint(x: 0.29513 * width, y: 0.67599 * height), control2: CGPoint(x: 0.27959 * width, y: 0.69153 * height))
        path.addCurve(to: CGPoint(x: 0.32737 * width, y: 0.7634 * height), control1: CGPoint(x: 0.27959 * width, y: 0.74437 * height), control2: CGPoint(x: 0.29901 * width, y: 0.7634 * height))
        path.closeSubpath()

        return path
    }
}

#Preview {
    PaymentSymbol()
        .frame(width: 20.0, height: 20.0)
}
