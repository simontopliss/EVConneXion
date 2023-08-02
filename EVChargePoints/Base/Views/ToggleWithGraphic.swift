//
//  ToggleWithGraphic.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 02/08/2023.
//

import SwiftUI

struct ToggleWithGraphic: View {

    let displayName: String
    let imageName: String
    var imageWidth: Double = 32.0
    var imageHeight: Double = 32.0

    @Binding var toggled: Bool

    var body: some View {
        HStack {
            SymbolImage(
                imageName: imageName,
                toggled: $toggled
            )
            Toggle(isOn: $toggled) {
                Text(displayName)
            }
        }
    }
}

#Preview {
    ToggleWithGraphic(
        displayName: "Dealership Forecourt",
        imageName: "dealership-forecourt-128x128",
        toggled: .constant(true)
    )
}
