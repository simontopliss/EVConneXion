//
//  StaticJSONMapper.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 02/07/2023.
//

import Foundation

enum StaticJSONMapper {

    static func decode<T: Decodable>(file: String, type _: T.Type) throws -> T {

        guard !file.isEmpty,
              let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path)
        else {
            throw MappingError.failedToGetContents
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }

}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
    }
}
