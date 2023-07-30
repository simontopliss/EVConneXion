//
//  FiltersViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation
import SwiftUI

final class FiltersViewModel: ObservableObject {

    @Published var locationFilters: [LocationFilter] = []

    init() {
        loadLocationFilters()
    }

    func loadLocationFilters() {
        self.locationFilters = try! StaticJSONMapper.decode(
            file: "LocationTypes",
            type: [LocationFilter].self
        )
    }
}
