import XCTest
import Foundation
@testable import WorldConquer

final class TerritoryTests: XCTestCase {
    var sut: Territory!
    var country: Country!

    override func setUp() {
        super.setUp()
        country = Country(name: "aCountry")
        sut = Territory(name: "someTerritory", population: 1, belongsTo: country)

    }

    override func tearDown() {
        sut = nil
        country = nil
        super.tearDown()
    }

    static var allTests = [
        ("testInitialSetup", testInitialSetup)
    ]

    func testInitialSetup() {
        XCTAssertEqual(sut.name, "someTerritory")
        XCTAssertEqual(sut.population, 1)
        XCTAssertEqual(sut.belongsTo, country)
        XCTAssertEqual(country.territories, [sut])
    }
}
