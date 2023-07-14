@testable import EVChargePoints
import XCTest

@MainActor
final class NetworkManagerTests: XCTestCase {

    private var session: URLSession! // swiftlint:disable:this implicitly_unwrapped_optional
    private var url: URL! // swiftlint:disable:this implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()

        url = URL(string: "https://chargepoints.dft.gov.uk/api/retrieve/registry/device-id/1b8a93def9107a6c38b35140c0a59ca0/format/json")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
    }

    override func tearDown() {
        session = nil
        url = nil
        super.tearDown()
    }

    func test_successfulResponse_isValid() async throws {

        guard let path = Bundle.main.path(forResource: "1b8a93def9107a6c38b35140c0a59ca0 - multiple RegularOpenings", ofType: "json"),
            let data = FileManager.default.contents(atPath: path) else {
                XCTFail("Failed to get the static users file")
                return
        }

        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: self.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            return (response!, data) // swiftlint:disable:this force_unwrapping
        }

        let chargePointData = try await NetworkManager.shared.request(url.absoluteString, type: ChargePointData.self)

        guard let chargeDevice = chargePointData.chargeDevices.first else {
            XCTFail("Failed to unwrap the charge device")
            return
        }

        let staticJSON = try StaticJSONMapper.decode(
            file: "1b8a93def9107a6c38b35140c0a59ca0 - multiple RegularOpenings",
            type: ChargePointData.self
        )

        XCTAssertEqual(chargeDevice.chargeDeviceID, staticJSON.chargeDevices[0].chargeDeviceID)
    }

    // TODO: Add tests for other response codes
}




