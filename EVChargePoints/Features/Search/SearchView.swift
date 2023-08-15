//
//  SearchView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct SearchView: View {

    @EnvironmentObject private var dataManager: DataManager
    @Environment(\.dismiss) var dismiss

    @FocusState private var isFocused: Bool
    @Binding var showSheet: Bool

    var body: some View {
        VStack {

            searchHeader

            Divider()

            if dataManager.userSettings.recentSearches.isEmpty {
                contentUnavailable
            } else {
                Section("Recent Searches") {
                    List(dataManager.userSettings.recentSearches, id: \.self) { recentSearch in
//                        ForEach(dataManager.userSettings.recentSearches, id: \.self) { recentSearch in
                        Text(recentSearch)
                            .foregroundStyle(AppColors.textColor)
                            .tag(recentSearch)
                            .onTapGesture {
                                print(recentSearch)
                                dismiss()
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
        .alert(isPresented: $dataManager.hasError, error: dataManager.networkError) {
            // TODO: Check NetworkManager.NetworkError errorDescription
            Button("Retry") {
                Task {
                    await dataManager.searchForChargeDevices()
                    dismiss()
                }
            }
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

extension SearchView {

    var searchHeader: some View {
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
                    dismiss()
                }
                // TODO: Navigate to MapView or ListView if successHU17 0RXful and zoom map to region from searchQuery
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
    }

    var contentUnavailable: some View {
        ContentUnavailableView(
            "No recent searches",
            systemImage: Symbols.noRecentSearchesSymbolName,
            description: Text("Your search history will automatically be displayed here.")
        )
        // .foregroundStyle(AppColors.textColor)
    }
}
