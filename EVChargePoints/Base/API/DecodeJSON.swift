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
            throw DecodeJSONError.keyNotFound(key: key, context: context)
        } catch let DecodingError.typeMismatch(_, context) {
            throw DecodeJSONError.typeMismatch(context: context)
        } catch let DecodingError.valueNotFound(type, context) {
            throw DecodeJSONError.valueNotFound(type: type, context: context)
        } catch DecodingError.dataCorrupted(_) {
            throw DecodeJSONError.dataCorrupted
        } catch {
            throw DecodeJSONError.unknownError(error: error)
        }
    }
}

extension DecodeJSON {
    enum DecodeJSONError: Error {
        case keyNotFound(key: CodingKey, context: DecodingError.Context)
        case typeMismatch(context: DecodingError.Context)
        case valueNotFound(type: Any.Type, context: DecodingError.Context)
        case dataCorrupted
        case unknownError(error: Error)
    }
}

extension DecodeJSON.DecodeJSONError {
    var errorDescription: String? {
        switch self {
            case let .keyNotFound(key, context):
                return "Failed to decode due to missing key '\(key.stringValue)' – \(context.debugDescription)"
            case let .typeMismatch(context):
                return "Failed to decode due to type mismatch – \(context.debugDescription)"
            case let .valueNotFound(type, context):
                return "Failed to decode due to missing \(type) value – \(context.debugDescription)"
            case .dataCorrupted:
                return "Failed to decode because it appears to be invalid JSON."
            case let .unknownError(error):
                return "Failed to decode: \(error.localizedDescription)"
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
