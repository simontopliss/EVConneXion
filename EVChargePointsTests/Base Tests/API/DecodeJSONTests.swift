@testable import EVChargePoints
import XCTest

@MainActor
final class DecodeJSONTests: XCTestCase {

    func test_validJSON_successfullyDecodes() {
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

    func test_withMissingFile_errorThrown() {
        XCTAssertThrowsError(
            try StaticJSONMapper.decode(file: "", type: ChargePointData.self),
            "An error should be thrown"
        )
        do {
            _ = try StaticJSONMapper.decode(file: "", type: ChargePointData.self)
        } catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of error for missing files")
                return
            }
            XCTAssertEqual(
                mappingError,
                StaticJSONMapper.MappingError.failedToGetContents,
                "This should be a failed to get contents error"
            )
        }
    }

    func test_withInvalidFile_errorThrown() {
        XCTAssertThrowsError(
            try StaticJSONMapper.decode(file: "dfddf", type: ChargePointData.self),
            "An error should be thrown"
        )
        do {
            _ = try StaticJSONMapper.decode(file: "dfdfdfd", type: ChargePointData.self)
        } catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of error for missing files")
                return
            }
            XCTAssertEqual(
                mappingError,
                StaticJSONMapper.MappingError.failedToGetContents,
                "This should be a failed to get contents error"
            )
        }
    }


}
