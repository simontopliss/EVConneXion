//
//  NetworkGraphic.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

struct NetworkGraphic: Decodable {
    let network: String
    let filename: String
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case network = "Network"
        case filename = "Filename"
        case displayName = "DisplayName"
    }
}
