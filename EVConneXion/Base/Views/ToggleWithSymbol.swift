//
//  ToggleWithSymbol.swift
//  EVConneXion
//
//  Created by Simon Topliss on 02/08/2023.
//

import SwiftUI

struct ToggleWithSymbol: View {

    let displayName: String
    let symbolName: String
    var symbolWidth: Double = Symbols.symbolWidth
    var symbolHeight: Double = Symbols.symbolHeight
    
    @Binding var toggled: Bool
    var itemID: UUID

    var body: some View {
        HStack {
            SFSymbolImageAnimated(
                symbolName: symbolName,
                toggled: $toggled
            )
            Toggle(isOn: $toggled) {
                Text(displayName)
            }
            .tag(itemID)
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
        toggled: .constant(true),
        itemID: UUID()
    )
}
