//
//  Validator.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

struct Validator {

    enum ValidFor {
        case website
        case telephoneNo
        case schemeCode
        case any
    }

    static func isValid(_ text: String, forType: ValidFor = .any) -> Bool {
        var isValid: Bool

        if text.trim().isEmpty {
            isValid = false
        } else {

            let trimmedText = text.trim()

            switch forType {

                case .any:
                    isValid = true

                case .website:
                    if trimmedText.contains("national-charge-point-registry") {
                        isValid = false
                    } else if trimmedText.hasPrefix("http://") ||
                        trimmedText.hasPrefix("https://") ||
                        trimmedText.hasPrefix("www.")
                    {
                        isValid = true
                    } else {
                        isValid = false
                    }

                case .telephoneNo:
                    if trimmedText == "101" ||
                        trimmedText == "777080846" ||
                        trimmedText == "NA" ||
                        trimmedText == "No phone number" ||
                        trimmedText == "tbc" ||
                        trimmedText == "tbd"
                    {
                        isValid = false
                    } else {
                        isValid = true
                    }

                case .schemeCode:
                    if trimmedText == "NOOWN" {
                        isValid = false
                    } else {
                        isValid = true
                    }
            }
        }
        return isValid
    }

    static func isValid(_ text: String?, forType: ValidFor = .any) -> Bool {
        if let text = text {
            return isValid(text)
        } else {
            return false
        }
    }
}
