//
//  StaticJSONMapper.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 02/07/2023.
//

import Foundation

enum StaticJSONMapper {

    static func decode<T: Decodable>(
        file: String,
        type _: T.Type,
        location: Location = .bundle,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> T {

        guard !file.isEmpty else { throw MappingError.failedToGetContents }

        let path: String?

        switch location {
            case .bundle:
                path = Bundle.main.path(forResource: file, ofType: "json")
            case .documents:
                path = FileManager.documentsDirectory
                    .appendingPathComponent(file)
                    .appendingPathExtension("json")
                    .path
        }

        guard let path,
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
            // print("request() error:\n" + String(describing: error))
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

extension StaticJSONMapper {
    enum Location {
        case bundle
        case documents
    }
}
