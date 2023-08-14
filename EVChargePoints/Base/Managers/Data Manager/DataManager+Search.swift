//
//  DataManager+Search.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 12/08/2023.
//

import Foundation

extension DataManager {

    @MainActor
    func searchForChargeDevices() async {
        // print(#function)
        searchError = false
        searchErrorMessage = ""
        searchQuery = searchQuery.trim()

        if !isSearchQueryValid() { return }

        isPostcode(postcode: searchQuery)
        ? await fetchChargeDevices(requestType: .postcode(searchQuery.localizedUppercase))
        : await fetchChargeDevices(requestType: .postTown(searchQuery))
    }

    // TODO: Add unit tests to confirm this works
    func isPostcode(postcode: String) -> Bool {
        return postcode.localizedUppercase.firstMatch(of: /^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$/) != nil
    }

    /*
     This version will also accept a postcode with a space between the two parts
     ^(([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9]?[A-Z])))) ?[0-9][A-Z]{2}$
     */

    func isSearchQueryValid() -> Bool {
        if searchQuery.isEmpty { return false }
        if searchQuery.count < 3 { // Is this min correct?
            searchError = true
            searchErrorMessage = "Search query should be more than two characters."
            return false
        }

        return true
    }

}
