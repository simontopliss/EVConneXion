//
//  FormLabelView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 10/08/2023.
//

import SwiftUI

struct FormLabel: View {
    let label: String

    var body: some View {
        VStack {
            Text(label)
                .font(.subheadline.leading(.tight))
                .multilineTextAlignment(.leading)
                .frame(width: 90, alignment: .leading)
                .foregroundStyle(.secondary)
        }
    }
}
