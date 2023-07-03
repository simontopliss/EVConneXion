//
//  UITestingHelper.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 03/07/2023.
//

#if DEBUG

import Foundation

enum UITestingHelper {

    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui-testing")
    }

    static var isNetworkingSuccessful: Bool {
        ProcessInfo.processInfo.environment["-networking-success"] == "1"
    }
}

#endif
