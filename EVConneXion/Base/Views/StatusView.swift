//
//  StatusView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 15/08/2023.
//

import SwiftUI

struct StatusView: View {

    @Environment(\.colorScheme) private var colorScheme

    var bool: Bool

    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .foregroundStyle(Color.white)
                .font(.title3)
                .fontWeight(.semibold)
                .shadow(color: (colorScheme == .dark ? .white.opacity(0.50) : .black.opacity(0.50)), radius: 3.0)

            Image(systemName: bool ? Symbols.yesName : Symbols.noName)
                .foregroundStyle(bool ? AppColors.yesColor : AppColors.noColor)
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    StatusView(bool: false)
}
