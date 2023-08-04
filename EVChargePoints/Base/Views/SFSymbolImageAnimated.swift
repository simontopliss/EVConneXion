//
//  SFSymbolImageAnimated.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SFSymbolImageAnimated: View {

    let symbolName: String
    var symbolWidth: Double = Symbols.symbolWidth
    var symbolHeight: Double = Symbols.symbolHeight

    @Binding var toggled: Bool

    var body: some View {
        Image(systemName: symbolName)
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
            .fontWeight(.regular)
            .opacity(toggled ? 1.0 : 0.4)
            .padding(.trailing, 6)
    }
}

#Preview {
    SFSymbolImageAnimated(
        symbolName: "wrongwaysign",
        toggled: .constant(false)
    )
}
