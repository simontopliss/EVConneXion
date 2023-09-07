//
//  SymbolImageAnimated.swift
//  EVConneXion
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SymbolImageAnimated: View {

    @Environment(\.colorScheme) var colorScheme

    let graphicName: String

    // Don't invert the graphic for Network
    var invertForDarkMode = true

    var symbolWidth: Double = Symbols.symbolWidth
    var symbolHeight: Double = Symbols.symbolHeight

    @Binding var toggled: Bool

    var body: some View {
        Image(graphicName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                maxWidth: symbolWidth,
                maxHeight: symbolHeight,
                alignment: .center
            )
            .scaleEffect(toggled ? 1.0 : 0.80)
            .opacity(toggled ? 1.0 : 0.5)
            .foregroundStyle(Color.accentColor)
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
            graphicName: "ubitricity",
            invertForDarkMode: false,
            toggled: .constant(false)
        )
        SymbolImageAnimated(
            graphicName: "ubitricity",
            invertForDarkMode: false,
            toggled: .constant(true)
        )
        SymbolImageAnimated(
            graphicName: "dealership-forecourt",
            invertForDarkMode: false,
            toggled: .constant(false)
        )
        SymbolImageAnimated(
            graphicName: "dealership-forecourt",
            invertForDarkMode: false,
            toggled: .constant(true)
        )
    }
}
