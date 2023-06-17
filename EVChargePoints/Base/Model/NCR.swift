// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let NCR = try? JSONDecoder().decode(NCR.self, from: jsonData)

import Foundation

// MARK: - NCR
struct NCR: Codable {
    let scheme: Scheme
    let chargeDevices: [ChargeDevice]

    enum CodingKeys: String, CodingKey {
        case scheme = "Scheme"
        case chargeDevices = "ChargeDevice"
    }
}

// MARK: - ChargeDevice
struct ChargeDevice: Codable {
    let chargeDeviceId: String
    let chargeDeviceRef: String
    let chargeDeviceName: String
    let chargeDeviceText: String?
    let chargeDeviceLocation: ChargeDeviceLocation
    let chargeDeviceManufacturer: String?
    let chargeDeviceModel: String?
    let publishStatusId: String
    let dateCreated: String
    let dateUpdated: String
    let attribution: String
    let dateDeleted: String
    let connector: [Connector]
    let deviceOwner: DeviceOwner
    let deviceController: DeviceController
    let deviceAccess: DeviceAccessUnion
    let deviceNetworks: String
    let chargeDeviceStatus: String
    let publishStatus: String
    let deviceValidated: String
    let recordModerated: String
    let recordLastUpdated: String?
    let recordLastUpdatedBy: String
    let paymentRequiredFlag: Bool
    let paymentDetails: String?
    let subscriptionRequiredFlag: Bool
    let subscriptionDetails: String?
    let parkingFeesFlag: Bool
    let parkingFeesDetails: String?
    let parkingFeesUrl: String?
    let accessRestrictionFlag: Bool
    let accessRestrictionDetails: String?
    let physicalRestrictionFlag: Bool
    let physicalRestrictionText: String?
    let onStreetFlag: Bool
    let locationType: String
    let bearing: String?
    let accessible24Hours: Bool

    enum CodingKeys: String, CodingKey {
        case chargeDeviceId = "ChargeDeviceId"
        case chargeDeviceRef = "ChargeDeviceRef"
        case chargeDeviceName = "ChargeDeviceName"
        case chargeDeviceText = "ChargeDeviceText"
        case chargeDeviceLocation = "ChargeDeviceLocation"
        case chargeDeviceManufacturer = "ChargeDeviceManufacturer"
        case chargeDeviceModel = "ChargeDeviceModel"
        case publishStatusId = "PublishStatusID"
        case dateCreated = "DateCreated"
        case dateUpdated = "DateUpdated"
        case attribution = "Attribution"
        case dateDeleted = "DateDeleted"
        case connector = "Connector"
        case deviceOwner = "DeviceOwner"
        case deviceController = "DeviceController"
        case deviceAccess = "DeviceAccess"
        case deviceNetworks = "DeviceNetworks"
        case chargeDeviceStatus = "ChargeDeviceStatus"
        case publishStatus = "PublishStatus"
        case deviceValidated = "DeviceValidated"
        case recordModerated = "RecordModerated"
        case recordLastUpdated = "RecordLastUpdated"
        case recordLastUpdatedBy = "RecordLastUpdatedBy"
        case paymentRequiredFlag = "PaymentRequiredFlag"
        case paymentDetails = "PaymentDetails"
        case subscriptionRequiredFlag = "SubscriptionRequiredFlag"
        case subscriptionDetails = "SubscriptionDetails"
        case parkingFeesFlag = "ParkingFeesFlag"
        case parkingFeesDetails = "ParkingFeesDetails"
        case parkingFeesUrl = "ParkingFeesUrl"
        case accessRestrictionFlag = "AccessRestrictionFlag"
        case accessRestrictionDetails = "AccessRestrictionDetails"
        case physicalRestrictionFlag = "PhysicalRestrictionFlag"
        case physicalRestrictionText = "PhysicalRestrictionText"
        case onStreetFlag = "OnStreetFlag"
        case locationType = "LocationType"
        case bearing = "Bearing"
        case accessible24Hours = "Accessible24Hours"
    }
}

// MARK: - ChargeDeviceLocation
struct ChargeDeviceLocation: Codable {
    let latitude: String
    let longitude: String
    let address: [String: String?]
    let locationShortDescription: String?
    let locationLongDescription: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
        case address = "Address"
        case locationShortDescription = "LocationShortDescription"
        case locationLongDescription = "LocationLongDescription"
    }
}

// MARK: - Connector
struct Connector: Codable {
    let connectorId: String
    let connectorType: String
    let ratedOutputkW: String
    let ratedOutputVoltage: String
    let ratedOutputCurrent: String
    let chargeMethod: String
    let chargeMode: String
    let chargePointStatus: String
    let tetheredCable: String
    let information: String?
    let validated: String

    enum CodingKeys: String, CodingKey {
        case connectorId = "ConnectorId"
        case connectorType = "ConnectorType"
        case ratedOutputkW = "RatedOutputkW"
        case ratedOutputVoltage = "RatedOutputVoltage"
        case ratedOutputCurrent = "RatedOutputCurrent"
        case chargeMethod = "ChargeMethod"
        case chargeMode = "ChargeMode"
        case chargePointStatus = "ChargePointStatus"
        case tetheredCable = "TetheredCable"
        case information = "Information"
        case validated = "Validated"
    }
}

enum DeviceAccessUnion: Codable {
    case anythingArray([JSONAny])
    case deviceAccessClass(DeviceAccessClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([JSONAny].self) {
            self = .anythingArray(x)
            return
        }
        if let x = try? container.decode(DeviceAccessClass.self) {
            self = .deviceAccessClass(x)
            return
        }
        throw DecodingError.typeMismatch(
            DeviceAccessUnion.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Wrong type for DeviceAccessUnion"
            )
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .anythingArray(let x):
                try container.encode(x)
            case .deviceAccessClass(let x):
                try container.encode(x)
        }
    }
}

// MARK: - DeviceAccessClass
struct DeviceAccessClass: Codable {
    let open24Hours: Bool?
    let regularOpenings: [RegularOpening]?
    let annualOpenings: [AnnualOpening]?

    enum CodingKeys: String, CodingKey {
        case open24Hours = "Open24Hours"
        case regularOpenings = "RegularOpenings"
        case annualOpenings = "AnnualOpenings"
    }
}

// MARK: - AnnualOpening
struct AnnualOpening: Codable {
    let date: String
    let hours: Hours

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case hours = "Hours"
    }
}

// MARK: - Hours
struct Hours: Codable {
    let from: String
    let to: String

    enum CodingKeys: String, CodingKey {
        case from = "From"
        case to = "To"
    }
}

// MARK: - RegularOpening
struct RegularOpening: Codable {
    let days: Days
    let hours: Hours

    enum CodingKeys: String, CodingKey {
        case days = "Days"
        case hours = "Hours"
    }
}

enum Days: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(
            Days.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Wrong type for Days"
            )
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .bool(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
        }
    }
}

// MARK: - DeviceController
struct DeviceController: Codable {
    let organisationName: String
    let schemeCode: String
    let website: String
    let telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName = "OrganisationName"
        case schemeCode = "SchemeCode"
        case website = "Website"
        case telephoneNo = "TelephoneNo"
    }
}

// MARK: - DeviceOwner
struct DeviceOwner: Codable {
    let organisationName: String
    let schemeCode: String
    let website: String
    let telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName = "OrganisationName"
        case schemeCode = "SchemeCode"
        case website = "Website"
        case telephoneNo = "TelephoneNo"
    }
}

// MARK: - Scheme
struct Scheme: Codable {
    let schemeCode: String
    let schemeData: SchemeData

    enum CodingKeys: String, CodingKey {
        case schemeCode = "SchemeCode"
        case schemeData = "SchemeData"
    }
}

// MARK: - SchemeData
struct SchemeData: Codable {
    let organisationName: String
    let website: String
    let telephoneNo: String

    enum CodingKeys: String, CodingKey {
        case organisationName = "OrganisationName"
        case website = "Website"
        case telephoneNo = "TelephoneNo"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(
                JSONNull.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Wrong type for JSONNull"
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Cannot decode JSONAny"
        )
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(
            codingPath: codingPath,
            debugDescription: "Cannot encode JSONAny"
        )
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(
        from container: inout UnkeyedDecodingContainer
    ) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(
        from container: inout KeyedDecodingContainer<JSONCodingKey>,
        forKey key: JSONCodingKey
    ) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(
        from container: inout UnkeyedDecodingContainer
    ) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(
        from container: inout KeyedDecodingContainer<JSONCodingKey>
    ) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(
        to container: inout UnkeyedEncodingContainer,
        array: [Any]
    ) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(
        to container: inout KeyedEncodingContainer<JSONCodingKey>,
        dictionary: [String: Any]
    ) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(
        to container: inout SingleValueEncodingContainer,
        value: Any
    ) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

@propertyWrapper public struct NilOnFail<T: Codable>: Codable {

    public let wrappedValue: T?
    public init(from decoder: Decoder) throws {
        wrappedValue = try? T(from: decoder)
    }
    public init(_ wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}
