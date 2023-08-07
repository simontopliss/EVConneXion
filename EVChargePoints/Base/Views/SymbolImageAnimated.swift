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

    var colorSchemeGraphicName: String {
        colorScheme == .dark ? graphicName + "-i" : graphicName
    }

    var tintGraphicName: String {
        colorScheme == .dark ? graphicName + "-60-i" : graphicName + "-60"
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
    SymbolImageAnimated(
        graphicName: "dealership-forecourt-128",
        toggled: .constant(true)
    )
}
