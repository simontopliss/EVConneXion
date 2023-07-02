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
    case routes
    case settings

    var label: String {
        switch self {
            case .map:
                return "Map"
            case .list:
                return "List"
            case .routes:
                return "Routes"
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
            case .routes:
                return "arrow.triangle.swap"
            case .settings:
                return "gearshape"
        }
    }
}
