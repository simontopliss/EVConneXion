//
//  TabModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import Foundation

enum Tabs: Int {

    case map
    case list
    case filters
    case settings

    var label: String {
        switch self {
            case .map:
                return "Map"
            case .list:
                return "List"
            case .filters:
                return "Filters"
            case .settings:
                return "Settings"
        }
    }

    var icon: String {
        switch self {
            case .map:
                return "map"
            case .list:
                return "list.bullet"
            case .filters:
                return "slider.horizontal.3"
            case .settings:
                return "gearshape"
        }
    }
}
