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
    var symbolWidth: Double = Symbols.symbolWidth
    var symbolHeight: Double = Symbols.symbolHeight

    @Binding var toggled: Bool

    var body: some View {
        HStack {
            SymbolImageAnimated(
                imageName: imageName,
                toggled: $toggled
            )
            Toggle(isOn: $toggled) {
                Text(displayName)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ToggleWithGraphic(
        displayName: "Dealership Forecourt",
        imageName: "dealership-forecourt-128x128",
        toggled: .constant(true)
    )
}
