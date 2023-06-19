//
//  NetworkManager.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func request<T: Decodable>(_ baseURL: String, type: T.Type) async throws -> T {

        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        print(url)

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode
        else { // swiftlint:disable:this indentation_width
            let statusCode = (response as! HTTPURLResponse).statusCode // swiftlint:disable:this force_cast
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedResponse = try decoder.decode(T.self, from: data)
            return decodedResponse
        } catch {
            print("request() error:\n" + String(describing: error))
            throw NetworkError.failedToDecode(error: error)
        }
    }
}

extension NetworkManager {
    enum NetworkError: LocalizedError {
        case invalidURL
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension NetworkManager.NetworkError {
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "URL isn't valid"
            case let .custom(error: error):
                return "Something went wrong; \(error.localizedDescription)"
            case let .invalidStatusCode(statusCode: statusCode):
                return "Status code falls into something went wrong range; \(statusCode)"
            case .invalidData:
                return "Response was invalid"
            case let .failedToDecode(error: error):
                return "Failed to decode; \(error.localizedDescription)"
        }
    }
}
