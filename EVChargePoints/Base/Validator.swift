//
//  Validator.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

struct Validator {

    static func isValid(_ text: String) -> Bool {
        !text.trim().isEmpty
    }

    static func isValid(_ text: String?) -> Bool {
        if let text = text {
            return isValid(text)
        } else {
            return false
        }
    }
}
