//
//  FormTextView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 10/08/2023.
//

import SwiftUI

struct FormText: View {
    let text: String

    var body: some View {
        Text(LocalizedStringKey(text.trim()))
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .foregroundStyle(AppColors.textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
