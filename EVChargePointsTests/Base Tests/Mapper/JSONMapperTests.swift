@testable import EVChargePoints
import XCTest

@MainActor
final class JSONMapperTests: XCTestCase {

    func test_withValidJson_successfullyDecodes() {
        XCTAssertNoThrow(
            try StaticJSONMapper.decode(file: "DE7 8LN", type: ChargePointData.self),
            "Mapper shouldn't throw an error"
        )

        let chargePointData = try? StaticJSONMapper.decode(file: "DE7 8LN", type: ChargePointData.self)
        XCTAssertNotNil(chargePointData, "Charge Point Data shouldn't be nil")

        let chargeDevices = chargePointData?.chargeDevices
        XCTAssertNotNil(chargeDevices, "Charge Devices shouldn't be nil")

        let chargeDevice = chargeDevices?.first!

    }


}
