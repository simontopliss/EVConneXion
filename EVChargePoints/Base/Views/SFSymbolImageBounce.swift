//
//  SFSymbolImageBounce.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SFSymbolImageBounce: View {

    let symbolName: String
    var symbolWidth: Double = Symbols.symbolWidth
    var symbolHeight: Double = Symbols.symbolHeight

    @Binding var toggled: Bool

    var body: some View {
        Image(systemName: symbolName)
            .symbolEffect(.bounce.up, value: toggled)
            .foregroundStyle(Color.accentColor)
            .font(.title)
            .fontWeight(.regular)
            .frame(
                maxWidth: symbolWidth,
                maxHeight: symbolHeight,
                alignment: .center
            )
            .padding(.trailing, 6)
    }
}

#Preview {
    SFSymbolImageBounce(
        symbolName: "wrongwaysign",
        toggled: .constant(false)
    )
}
