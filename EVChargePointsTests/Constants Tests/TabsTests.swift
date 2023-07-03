@testable import EVChargePoints
import XCTest

@MainActor
final class TabsTests: XCTestCase {

    func test_tabsOrder() {
        XCTAssertEqual(Tabs.map.rawValue, 0)
        XCTAssertEqual(Tabs.list.rawValue, 1)
        XCTAssertEqual(Tabs.routes.rawValue, 2)
        XCTAssertEqual(Tabs.settings.rawValue, 3)
    }

    func test_tabLabels() {
        XCTAssertEqual(Tabs.map.label, "Map")
        XCTAssertEqual(Tabs.list.label, "List")
        XCTAssertEqual(Tabs.routes.label, "Routes")
        XCTAssertEqual(Tabs.settings.label, "Settings")
    }

    func test_tabIcons() {
        XCTAssertEqual(Tabs.map.icon, "map")
        XCTAssertEqual(Tabs.list.icon, "list.bullet")
        XCTAssertEqual(Tabs.routes.icon, "arrow.triangle.swap")
        XCTAssertEqual(Tabs.settings.icon, "gearshape")
    }
}
