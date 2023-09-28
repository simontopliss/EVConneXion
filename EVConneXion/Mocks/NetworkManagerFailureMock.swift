//
//  NetworkManagerFailureMock.swift
//  iOSTakeHomeProjectTests
//
//  Created by Simon Topliss on 30/06/2023.
//

#if DEBUG

import Foundation

final class NetworkManagerFailureMock: NetworkManagerImpl {
    func request<T>(_ baseURL: String, type: T.Type) async throws -> T where T: Decodable {
        throw NetworkManager.NetworkError.invalidURL
    }
}

#endif
