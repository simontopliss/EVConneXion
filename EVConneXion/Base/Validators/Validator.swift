//
//  Validator.swift
//  EVConneXion
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

enum Validator {

    enum ValidFor {
        case website
        case telephoneNo
        case schemeCode
        case parking
        case details
        case any
    }

    // swiftlint:disable:next cyclomatic_complexity
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
                        trimmedText.hasPrefix("www.") {
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
                        trimmedText == "tbd" {
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

                case .parking, .details:
                    if trimmedText == "0" || trimmedText == "1" {
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
            return isValid(text, forType: forType)
        } else {
            return false
        }
    }
}
