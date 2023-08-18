//
//  MapPinView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 28/07/2023.
//

import SwiftUI

struct MapPinView: View {

    var height: Double = 30.0
    var width: Double = 18.75

    var pinColor: Color = .accentColor

    var body: some View {
        MapPin()
            .fill(pinColor)
            .frame(width: width, height: height, alignment: .center)
            .shadow(color: .accentColor.opacity(0.50), radius: 3.0)
            .overlay {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.white)
                    .scaleEffect(0.90)
                    .offset(y: -1.75)
            }
    }
}

#Preview {
    MapPinView(height: 30.0, pinColor: .accentColor)
}
