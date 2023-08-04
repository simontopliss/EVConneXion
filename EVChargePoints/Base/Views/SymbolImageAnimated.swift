//
//  SymbolImageAnimated.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SymbolImageAnimated: View {

    let imageName: String
    var tintImageName: String {
        imageName + "-60"
    }
    var symbolWidth: Double = Symbols.symbolWidth
    var symbolHeight: Double = Symbols.symbolHeight

    @Binding var toggled: Bool

    var body: some View {
        Image(toggled == true ? imageName : tintImageName)
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
        imageName: "dealership-forecourt-128x128",
        toggled: .constant(true)
    )
}
