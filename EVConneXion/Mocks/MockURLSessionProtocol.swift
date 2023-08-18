//
//  MockURLSessionProtocol.swift
//  EVConneXion
//
//  Created by Simon Topliss on 03/07/2023.
//

#if DEBUG

import Foundation

final class MockURLSessionProtocol: URLProtocol {

    static var loadingHandler: (() -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {

        guard let handler = MockURLSessionProtocol.loadingHandler else {
            fatalError("Loading handler is not set.")
        }

        let (response, data) = handler()
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

#endif
