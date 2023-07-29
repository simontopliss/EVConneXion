//
//  PaymentSymbolView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct PaymentSymbolView: View {

    var height: Double = 20.0
    var width: Double {
        height
    }

    var symbolColor: Color = .black

    var body: some View {
        PaymentSymbol()
            .fill(.black)
            .frame(width: width, height: height, alignment: .center)
    }
}

#Preview {
    PaymentSymbolView()
}
