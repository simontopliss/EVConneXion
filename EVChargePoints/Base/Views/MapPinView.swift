//
//  MapPinView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 28/07/2023.
//

import SwiftUI

struct MapPinView: View {

    var height: Double = 30.0
    var width: Double {
        height * 0.625
    }

    var pinColor: Color = .accentColor

    var body: some View {
        MapPin()
            .fill(pinColor)
            .frame(width: width, height: height, alignment: .center)
//            .overlay {
//                MapPin()
//                    .stroke(Color.black, lineWidth: 1.0)
//            }
            .shadow(color: .secondary, radius: 3.0)
            .overlay {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.white)
                    .scaleEffect(0.85)
                    .offset(y: -1.75)
            }
    }
}

#Preview {
    MapPinView(height: 30.0, pinColor: .cyan)
}
