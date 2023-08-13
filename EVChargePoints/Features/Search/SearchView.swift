//
//  SearchView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct SearchView: View {

    @EnvironmentObject private var dataManager: DataManager

    @Binding var showSheet: Bool
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                TextField(
                    "Search",
                    text: $dataManager.searchQuery,
                    prompt: Text("Enter postcode, town or city…")
                )
                .focused($isFocused)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundStyle(AppColors.textColor)
                .onSubmit {
                    Task {
                        await dataManager.searchForChargeDevices()
                    }
                }
                .submitLabel(.search)

                Button(role: .cancel) {
                    showSheet.toggle()
                } label: {
                    XmarkButtonView(foregroundColor: .gray)
                }
                .offset(y: 2.5)
                .padding(.bottom)
            }

            Divider()

            if dataManager.userSettings.recentSearches.isEmpty {

                ContentUnavailableView(
                    "No recent searches",
                    systemImage: Symbols.noRecentSearchesSymbolName,
                    description: Text("Your search history will automatically be displayed here.")
                )
                // .foregroundStyle(AppColors.textColor)

            } else {

                List { // Add selection
                    Section("Recent Searches") {
                        ForEach(dataManager.userSettings.recentSearches, id: \.self) {
                            Text($0)
                                .foregroundStyle(AppColors.textColor)
                        }
                    }
                }
                .listStyle(InsetListStyle())
            }
        }
        .padding()
        .alert("Warning", isPresented: $dataManager.searchError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(dataManager.searchErrorMessage)
        }
        .padding(.top)
        .onAppear {
            isFocused = true
        }
//        .overlay(alignment: .topTrailing) {
//            Button(role: .cancel) {
//                showSheet.toggle()
//            } label: {
//                XmarkButtonView(foregroundColor: .primary.opacity(0.2))
//            }
//            .padding([.top, .trailing])
//        }
    }
}

#Preview {
    SearchView(showSheet: .constant(true))
        .environmentObject(DataManager())
    // .environment(\.colorScheme, .dark)
}