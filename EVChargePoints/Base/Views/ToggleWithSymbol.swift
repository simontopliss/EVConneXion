//
//  ToggleWithSymbol.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 02/08/2023.
//

import SwiftUI

struct ToggleWithSymbol: View {

    let displayName: String
    let symbolName: String
    var imageWidth: Double = 32.0
    var imageHeight: Double = 32.0

    @Binding var toggled: Bool

    var body: some View {
        HStack {
            SFSymbolImageAnimated(
                symbolName: symbolName,
                toggled: $toggled
            )
            Toggle(isOn: $toggled) {
                Text(displayName)
            }
        }
        .font(.headline)
        .foregroundStyle(AppColors.textColor)
        .padding(.vertical, 4)
    }
}

#Preview {
    ToggleWithSymbol(
        displayName: "Payment Required",
        symbolName: "sterlingsign.circle",
        toggled: .constant(true)
    )
}
