@testable import EVChargePoints
import XCTest

@MainActor
final class EndpointTests: XCTestCase {

    func test_baseURL_isCorrect() {
        let baseURL = Endpoint.baseURL.rawValue

        XCTAssertEqual(baseURL, "https://chargepoints.dft.gov.uk/api/retrieve")
    }

    func test_DataType_staticValuesAreCorrect() {
        let registry = Endpoint.DataType.registry
        let connectorType = Endpoint.DataType.connectorType
        let bearing = Endpoint.DataType.bearing
        let chargingMethod = Endpoint.DataType.chargingMethod
        let chargingMode = Endpoint.DataType.chargingMode
        let connectorStatus = Endpoint.DataType.connectorStatus

        XCTAssertEqual(registry, "registry")
        XCTAssertEqual(connectorType, "type")
        XCTAssertEqual(bearing, "bearing")
        XCTAssertEqual(chargingMethod, "method")
        XCTAssertEqual(chargingMode, "mode")
        XCTAssertEqual(connectorStatus, "status")
    }

    func test_RegistryDataType_staticValuesAreCorrect() {
        let connectorTypeID = Endpoint.RegistryDataType.connectorTypeID
        let country = Endpoint.RegistryDataType.country
        let deviceId = Endpoint.RegistryDataType.deviceId
        let dist = Endpoint.RegistryDataType.dist
        let id = Endpoint.RegistryDataType.id
        let lat = Endpoint.RegistryDataType.lat
        let long = Endpoint.RegistryDataType.long
        let limit = Endpoint.RegistryDataType.limit
        let postcode = Endpoint.RegistryDataType.postcode
        let postTown = Endpoint.RegistryDataType.postTown
        let ratedOutputKW = Endpoint.RegistryDataType.ratedOutputKW
        let units = Endpoint.RegistryDataType.units

        let km = Endpoint.RegistryDataType.Unit.km.rawValue
        let mi = Endpoint.RegistryDataType.Unit.mi.rawValue

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
        let xml = Endpoint.RequestFormatOption.xml.rawValue
        let json = Endpoint.RequestFormatOption.json.rawValue
        let csv = Endpoint.RequestFormatOption.csv.rawValue

        XCTAssertEqual(xml, "format/xml")
        XCTAssertEqual(json, "format/json")
        XCTAssertEqual(csv, "format/csv")
    }

    // func test_RequestType_enumCasesAreCorrect() {
    //     let postcode = "DE7 8LN"
    //     XCTAssertEqual(postcode, "DE7 8LN")
    // }

    func test_buildURL_succeedsForPostcode() {
        let postcodeURL = Endpoint.buildURL(
            requestType: .postcode("DE7 8LN"),
            distance: 0,
            limit: 5,
            units: .mi,
            country: .gb
        )

        XCTAssertEqual(
            postcodeURL,
            "https://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/DE7+8LN/dist/0/units/limit/5/mi/format/json"
        )
    }

    func test_buildURL_succeedsForPostTown() {
        let postTownURL = Endpoint.buildURL(
            requestType: .postTown("South Shields"),
            distance: 0,
            limit: 5,
            units: .mi,
            country: .gb
        )

        XCTAssertEqual(
            postTownURL,
            "https://chargepoints.dft.gov.uk/api/retrieve/registry/post-town/South%20Shields/dist/0/units/limit/5/mi/format/json"
        )
    }

    // TODO: Write failing test for `distance` and `limit` if negative

}
