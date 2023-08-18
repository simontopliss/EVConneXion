//
//  DataManager+Search.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 12/08/2023.
//

import Foundation

extension DataManager {

    @MainActor
    func searchForChargeDevices(searchQuery: String) async {
        print(#function)
        
        searchError = false
        searchErrorMessage = ""
        var searchQuery = searchQuery.trim()

        if !isSearchQueryValid(searchQuery: searchQuery) { return }

        isPostcode(postcode: searchQuery)
        ? await fetchChargeDevices(requestType: .postcode(searchQuery.localizedUppercase))
        : await fetchChargeDevices(requestType: .postTown(searchQuery))

        if (networkError == nil) {
            let result = recentSearches.filter { $0.searchQuery == searchQuery }
            if result.isEmpty {
                recentSearches.insert(RecentSearch(searchQuery: searchQuery), at: 0)
                saveSettings(.recentSearches)
            }
            searchQuery = ""
        }
    }

    // TODO: Add unit tests to confirm this works
    func isPostcode(postcode: String) -> Bool {
        return postcode.localizedUppercase.firstMatch(of: /^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$/) != nil
    }

    /*
     This version will also accept a postcode without a space between the two parts
     /^(([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9]?[A-Z])))) ?[0-9][A-Z]{2}$/
     */

    func isSearchQueryValid(searchQuery: String) -> Bool {
        if searchQuery.isEmpty { return false }
        if searchQuery.count < 3 { // Is this min correct?
            searchError = true
            searchErrorMessage = "Search query should be more than two characters."
            return false
        }

        return true
    }

}
