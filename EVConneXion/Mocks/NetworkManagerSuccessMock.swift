//
//  NetworkingManagerCreateSuccessMock.swift
//  iOSTakeHomeProjectTests
//
//  Created by Simon Topliss on 30/06/2023.
//

#if DEBUG

import Foundation

final class NetworkManagerSuccessMock: NetworkManagerImpl {
    func request<T>(_ baseURL: String, type: T.Type) async throws -> T where T: Decodable {
        return Data() as! T // swiftlint:disable:this force_cast
    }
}

#endif
