@testable import EVConneXion
import XCTest

@MainActor
final class EndpointTests: XCTestCase {

    func test_baseURL_isCorrect() {
        let baseURL = ChargePointsEndpoint.baseURL.rawValue

        XCTAssertEqual(baseURL, "https://chargepoints.dft.gov.uk/api/retrieve")
    }

    func test_DataType_staticValuesAreCorrect() {
        let registry = ChargePointsEndpoint.DataType.registry
        let connectorType = ChargePointsEndpoint.DataType.connectorType
        let bearing = ChargePointsEndpoint.DataType.bearing
        let chargingMethod = ChargePointsEndpoint.DataType.chargingMethod
        let chargingMode = ChargePointsEndpoint.DataType.chargingMode
        let connectorStatus = ChargePointsEndpoint.DataType.connectorStatus

        XCTAssertEqual(registry, "registry")
        XCTAssertEqual(connectorType, "type")
        XCTAssertEqual(bearing, "bearing")
        XCTAssertEqual(chargingMethod, "method")
        XCTAssertEqual(chargingMode, "mode")
        XCTAssertEqual(connectorStatus, "status")
    }

    func test_RegistryDataType_staticValuesAreCorrect() {
        let connectorTypeID = ChargePointsEndpoint.RegistryDataType.connectorTypeID
        let country = ChargePointsEndpoint.RegistryDataType.country
        let deviceId = ChargePointsEndpoint.RegistryDataType.deviceId
        let dist = ChargePointsEndpoint.RegistryDataType.dist
        let id = ChargePointsEndpoint.RegistryDataType.id
        let lat = ChargePointsEndpoint.RegistryDataType.lat
        let long = ChargePointsEndpoint.RegistryDataType.long
        let limit = ChargePointsEndpoint.RegistryDataType.limit
        let postcode = ChargePointsEndpoint.RegistryDataType.postcode
        let postTown = ChargePointsEndpoint.RegistryDataType.postTown
        let ratedOutputKW = ChargePointsEndpoint.RegistryDataType.ratedOutputKW
        let units = ChargePointsEndpoint.RegistryDataType.units

        let km = ChargePointsEndpoint.RegistryDataType.Unit.km.rawValue
        let mi = ChargePointsEndpoint.RegistryDataType.Unit.mi.rawValue

        XCTAssertEqual(connectorTypeID, "connector-type-id")
        XCTAssertEqual(country, "country")
        XCTAssertEqual(deviceId, "device-id")
        XCTAssertEqual(dist, "dist")
        XCTAssertEqual(id, "id")
        XCTAssertEqual(lat, "lat")
        XCTAssertEqual(long, "long")
        XCTAssertEqual(limit, "limit")
        XCTAssertEqual(postcode, "postcode")
        XCTAssertEqual(postTown, "post-town")
        XCTAssertEqual(ratedOutputKW, "rated-output-kw")
        XCTAssertEqual(units, "units")

        XCTAssertEqual(km, "km")
        XCTAssertEqual(mi, "mi")
    }

    func test_RequestFormatOption_enumCasesAreCorrect() {
        let xml = ChargePointsEndpoint.RequestFormatOption.xml.rawValue
        let json = ChargePointsEndpoint.RequestFormatOption.json.rawValue
        let csv = ChargePointsEndpoint.RequestFormatOption.csv.rawValue

        XCTAssertEqual(xml, "format/xml")
        XCTAssertEqual(json, "format/json")
        XCTAssertEqual(csv, "format/csv")
    }

    // func test_RequestType_enumCasesAreCorrect() {
    //     let postcode = "DE7 8LN"
    //     XCTAssertEqual(postcode, "DE7 8LN")
    // }

    func test_buildURL_succeedsForPostcode() {
        let postcodeURL = ChargePointsEndpoint.buildURL(
            requestType: .postcode("DE7 8LN"),
            distance: 0.0,
            limit: 5,
            units: .mi,
            country: .gb
        )

        XCTAssertEqual(
            postcodeURL,
            "https://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/DE7+8LN/dist/0.0/units/limit/5/mi/format/json"
        )
    }

    func test_buildURL_succeedsForPostTown() {
        let postTownURL = ChargePointsEndpoint.buildURL(
            requestType: .postTown("South Shields"),
            distance: 0.0,
            limit: 5,
            units: .mi,
            country: .gb
        )

        XCTAssertEqual(
            postTownURL,
            "https://chargepoints.dft.gov.uk/api/retrieve/registry/post-town/South%20Shields/dist/0.0/units/limit/5/mi/format/json"
        )
    }

    // TODO: Write failing test for `distance` and `limit` if negative

}
