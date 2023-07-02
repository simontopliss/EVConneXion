@testable import EVChargePoints
import XCTest

@MainActor
final class ChargePointViewModel: XCTestCase {

    private var chargePointViewModel: ChargePointViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        chargePointViewModel = ChargePointViewModel()
    }

    override func tearDownWithError() throws {
        chargePointViewModel = nil
        try super.tearDownWithError()
    }
}
