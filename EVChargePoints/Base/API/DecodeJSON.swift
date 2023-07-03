//
//  DecodeJSON.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 02/07/2023.
//

import Foundation

enum DecodeJSON {

    func decode<T: Decodable>(
        data: Data,
        type _: T.Type,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> T {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            // fatalError("Failed to decode due to missing key '\(key.stringValue)' – \(context.debugDescription)")
            throw DecodeJSONError.keyNotFound("Failed to decode due to missing key '\(key.stringValue)' – \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(_, context) {
            // fatalError("Failed to decode due to type mismatch – \(context.debugDescription)")
            throw DecodeJSONError.typeMismatch(description: context.debugDescription)
        } catch let DecodingError.valueNotFound(type, context) {
            // fatalError("Failed to decode due to missing \(type) value – \(context.debugDescription)")
            throw DecodeJSONError.valueNotFound(type: type, description: context.debugDescription)
        } catch DecodingError.dataCorrupted(_) {
            //fatalError("Failed to decode because it appears to be invalid JSON.")
            throw DecodeJSONError.dataCorrupted(description: "Failed to decode because it appears to be invalid JSON.")
        } catch {
            fatalError("Failed to decode: \(error.localizedDescription)")
        }
    }
}

extension DecodeJSON {
    enum DecodeJSONError: Error {
        case keyNotFound(error: Error)
        case typeMismatch(error: Error)
        case valueNotFound(error: Error)
        case dataCorrupted(error: Error)
        case unknownError(error: Error)
    }
}
