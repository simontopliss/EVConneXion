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
        return postcode.localizedUppercase.firstMatch(of: /^[A-Z]{1,2}([0-9][A-Z]|[0-9]{1,2})\\s[0-9][A-Z]{2}/) != nil
    }

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
