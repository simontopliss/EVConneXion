//
//  SearchView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct SearchView: View {

    @Binding var showSheet: Bool

    // TDOD: Store in UserDefautlts
    let recentSearches = ["Bingley, BD16 1BE, England", "Beverley, HU17 ORX, England", "Erewash, DE7 8LN, England"]

    var body: some View {
        VStack {
            // TODO: Show recent searches
            List { // Add selection
                Section("Recent Searches") {
                    ForEach(recentSearches, id: \.self) {
                        Text($0)
                            .foregroundStyle(AppColors.textColor)
                    }
                }
            }
            .listStyle(InsetListStyle())
        }
        .padding(.top)
        .overlay(alignment: .topTrailing) {
            Button(role: .cancel) {
                showSheet.toggle()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.black.opacity(0.20))
                    .background(.white, in: .circle)
            }
            .padding([.top, .trailing])
        }
    }
}

#Preview {
    SearchView(showSheet: .constant(true))
}
