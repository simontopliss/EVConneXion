//
//  SymbolImageAnimated.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SymbolImageAnimated: View {

    @Environment(\.colorScheme) var colorScheme

    let graphicName: String

    // Don't invert the graphic for Network as they don't have an inverted version
    var invertTintForDarkMode = true

    var colorSchemeGraphicName: String {
        colorScheme == .dark ? graphicName + "-i" : graphicName
    }

    var tintGraphicName: String {
        if invertTintForDarkMode {
            return colorScheme == .dark ? graphicName + "-40-i" : graphicName + "-40"
        } else {
            return graphicName + "-40"
        }
    }

    var symbolWidth: Double = Symbols.symbolWidth
    var symbolHeight: Double = Symbols.symbolHeight

    @Binding var toggled: Bool

    var body: some View {
        Image(toggled == true ? colorSchemeGraphicName : tintGraphicName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                maxWidth: symbolWidth,
                maxHeight: symbolHeight,
                alignment: .center
            )
            .scaleEffect(toggled ? 1.0 : 0.80)
            .animation(
                .spring(duration: 0.5, bounce: 0.80)
                .repeatCount(1, autoreverses: true),
                value: toggled
            )
            .padding(.trailing, 6)
    }
}

#Preview {
    VStack {
        SymbolImageAnimated(
            graphicName: "dealership-forecourt",
            toggled: .constant(false)
        )
        SymbolImageAnimated(
            graphicName: "dealership-forecourt",
            toggled: .constant(true)
        )
    }
}
