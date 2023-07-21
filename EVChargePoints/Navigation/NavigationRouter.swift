//
//  NavigationRouter.swift
//  EVChargePoints
//
//  Created by Simon Topliss 20/07/2023.
//

import Foundation
import Observation
import SwiftUI

@Observable final class NavigationRouter: ObservableObject {

    var routes = [Route]()

    func push(to screen: Route) {
        routes.append(screen)
    }

    func goBack() {
        _ = routes.popLast()
    }

    func reset() {
        routes = []
    }
}
