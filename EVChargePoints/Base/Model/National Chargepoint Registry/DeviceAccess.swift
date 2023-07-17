//
//  DeviceAccess.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

// MARK: - DeviceAccess

struct DeviceAccess: Decodable {
    var open24Hours: Bool = false
    var regularOpenings: [RegularOpening]?

    enum CodingKeys: String, CodingKey {
        case open24Hours      = "Open24Hours"
        case regularOpenings  = "RegularOpenings"
    }
}

extension DeviceAccess {
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            open24Hours = try container.decode(Bool.self, forKey: .open24Hours)
        } catch {
            open24Hours = false
        }

        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            regularOpenings = try container.decodeIfPresent([RegularOpening].self, forKey: .regularOpenings)
        } catch {
            // print(error)
            regularOpenings = nil
        }
    }
}

// MARK: - RegularOpening

struct RegularOpening: Codable {
    var days: String?
    var hours: Hours?
    var allDays = false

    enum CodingKeys: String, CodingKey {
        case days   = "Days"
        case hours  = "Hours"
        case allDays
    }
}

extension RegularOpening {
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            days = try container.decode(String.self, forKey: .days)
        } catch {
            days = nil
            allDays = true
        }

        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            hours = try container.decode(Hours.self, forKey: .hours)
        } catch {
            hours = nil
        }
    }
}

// MARK: - Hours

struct Hours: Codable {
    var from: String
    var to: String

    enum CodingKeys: String, CodingKey {
        case from  = "From"
        case to    = "To"
    }
}
