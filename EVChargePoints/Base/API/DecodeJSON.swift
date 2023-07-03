//
//  DecodeJSON.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 02/07/2023.
//

import Foundation

enum DecodeJSON {

    static func decode<T: Decodable>(
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
            throw DecodeJSONError.keyNotFound(
                error: "Failed to decode due to missing key '\(key.stringValue)' – \(context.debugDescription)" as! Error
            )
        } catch let DecodingError.typeMismatch(_, context) {
            throw DecodeJSONError.typeMismatch(
                error: "Failed to decode due to type mismatch – \(context.debugDescription)" as! Error
            )
        } catch let DecodingError.valueNotFound(type, context) {
            throw DecodeJSONError.valueNotFound(
                error: "Failed to decode due to missing \(type) value – \(context.debugDescription)" as! Error
            )
        } catch DecodingError.dataCorrupted(_) {
            throw DecodeJSONError.dataCorrupted(
                error: "Failed to decode because it appears to be invalid JSON." as! Error
            )
        } catch {
            throw DecodeJSONError.unknownError(
                error: "Failed to decode: \(error.localizedDescription)" as! Error
            )
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

extension DecodeJSON.DecodeJSONError {
    var errorDescription: String? {
        switch self {
            case let .keyNotFound(error):
                return error.localizedDescription
            case let .typeMismatch(error):
                return error.localizedDescription
            case let .valueNotFound(error):
                return error.localizedDescription
            case let .dataCorrupted(error):
                return error.localizedDescription
            case let .unknownError(error):
                return error.localizedDescription
        }
    }
}

extension DecodeJSON.DecodeJSONError: Equatable {
    static func == (lhs: DecodeJSON.DecodeJSONError, rhs: DecodeJSON.DecodeJSONError) -> Bool {
        switch (lhs, rhs) {
            case (.keyNotFound, .keyNotFound):
                return true
            case (.typeMismatch, .typeMismatch):
                return true
            case (.valueNotFound, .valueNotFound):
                return true
            case (.dataCorrupted, .dataCorrupted):
                return true
            case (.unknownError, .unknownError):
                return true
            default:
                return false
        }
    }
}
