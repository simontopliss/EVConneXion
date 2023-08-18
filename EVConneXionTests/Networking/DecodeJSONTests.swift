@testable import EVConneXion
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
    }

    func test_failedToParseJSON_throws() {
        XCTAssertThrowsError(
            try StaticJSONMapper.decode(
                file: "4f5a97cf06cf69028997db51d8726d28 - missing ChargeDeviceName",
                type: ChargePointData.self
            ),
            "An error should be thrown"
        )
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

    func test_chargeDevice_decodesSuccessfully() {
        let chargePointData = try? StaticJSONMapper.decode(
            file: "d200029c1c2e679c9b434db0a79fdb60 - contains DeviceAccess example",
            type: ChargePointData.self
        )

        guard let chargeDevice = chargePointData?.chargeDevices.first! else {
            XCTFail("Failed to unwrap the charge device")
            return
        }

        XCTAssertEqual(chargeDevice.chargeDeviceID, "d200029c1c2e679c9b434db0a79fdb60")
        XCTAssertEqual(chargeDevice.chargeDeviceName, "50 St James's Road")
        XCTAssertEqual(chargeDevice.chargeDeviceLocation.latitude, "51.496371")
        XCTAssertEqual(chargeDevice.chargeDeviceLocation.longitude, "-0.065826")
        XCTAssertEqual(chargeDevice.connector.count, 1)

        let deviceOwner = chargeDevice.deviceOwner
        XCTAssertEqual(deviceOwner.organisationName, "London Borough of Southwark")

        let connector = chargeDevice.connector.first!
        XCTAssertEqual(connector.connectorType.rawValue, "Type 2 Mennekes (IEC62196)")
        XCTAssertEqual(connector.ratedOutputkW, 3.7)
        XCTAssertEqual(connector.chargeMethod.rawValue, "Single Phase AC")
    }

    func test_regularOpenings_decodeSuccessfullyForMultipleDays() {

        let chargePointData = try? StaticJSONMapper.decode(
            file: "1b8a93def9107a6c38b35140c0a59ca0 - multiple RegularOpenings",
            type: ChargePointData.self
        )

        guard let chargeDevice = chargePointData?.chargeDevices.first! else {
            XCTFail("Failed to unwrap the charge device")
            return
        }

        XCTAssertEqual(chargeDevice.chargeDeviceID, "1b8a93def9107a6c38b35140c0a59ca0")

        let deviceAccess = chargeDevice.deviceAccess
        let regularOpenings = deviceAccess?.regularOpenings
        XCTAssertEqual(regularOpenings?.count, 4)
        XCTAssertEqual(regularOpenings?[0].days, "Tuesday")
    }
}
