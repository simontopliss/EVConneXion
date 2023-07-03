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

        do {
            let decodedResponse = try DecodeJSON.decode(
                data: data,
                type: T.self,
                keyDecodingStrategy: .convertFromSnakeCase
            )
            return decodedResponse
        } catch {
            print("request() error:\n" + String(describing: error))
            if let decodeError = error as? DecodeJSON.DecodeJSONError {
                throw decodeError
            } else {
                throw StaticJSONMapper.MappingError.failedToGetContents
            }
        }
    }

}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
    }
}
