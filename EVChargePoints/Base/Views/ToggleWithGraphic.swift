//
//  ToggleWithGraphic.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 02/08/2023.
//

import SwiftUI

struct ToggleWithGraphic: View {

    let displayName: String
    let graphicName: String
    var symbolWidth: Double = Symbols.symbolWidth
    var symbolHeight: Double = Symbols.symbolHeight

    @Binding var toggled: Bool
    var itemID: UUID

    var body: some View {
        HStack {
            SymbolImageAnimated(
                graphicName: graphicName,
                toggled: $toggled
            )
            Toggle(isOn: $toggled) {
                Text(displayName)
            }
            .tag(itemID)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ToggleWithGraphic(
        displayName: "Dealership Forecourt",
        graphicName: "dealership-forecourt",
        toggled: .constant(true),
        itemID: UUID()
    )
}
