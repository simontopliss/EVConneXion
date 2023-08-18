//
//  Postcode.swift
//  SearchAutocompletion
//
//  Created by Simon Topliss on 17/08/2023.
//

import Foundation

struct Postcode: Decodable {
    let id = UUID()
    var postcode: String
    var latitude: Double
    var longitude: Double
    var town: String
    var county: String

    var townAndCounty: String {
        if town == county {
            return town
        } else {
            return "\(town), \(county)"
        }
    }

    enum CodingKeys: CodingKey {
        case postcode
        case latitude
        case longitude
        case town
        case county
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postcode = try container.decode(String.self, forKey: .postcode)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.town = try container.decode(String.self, forKey: .town)
        self.county = try container.decode(String.self, forKey: .county)
    }
}

//extension Postcode {
//    static func loadPostcodes() -> [Postcode] {
//        return try! StaticJSONMapper.decode(
//            file: "uk-postcodes",
//            type: [Postcode].self,
//            location: .bundle
//        )
//    }
//}
