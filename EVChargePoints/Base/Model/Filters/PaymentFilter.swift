//
//  PaymentFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

enum PaymentFilter {

    case paymentRequired
    case subscriptionRequired

    func displayName(_ key: PaymentFilter) -> String {
        switch self {
            case .paymentRequired:
                return "Payment Required"
            case .subscriptionRequired:
                return "Subscription Required"
        }
    }
}
