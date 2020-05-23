import XCTest
import Foundation
@testable import WorldConquer

final class ContinentTests: XCTestCase {
    var sut: Continent!
    var country: Country!
    var territory: Territory!

    override func setUp() {
        super.setUp()
        country = Country(name: "aCountry")
        territory = Territory(name: "someTerritory", population: 1, belongsTo: country)
        sut = Continent(name: "aContinent", territories: [territory])
    }

    override func tearDown() {
        sut = nil
        country = nil
        territory = nil
        super.tearDown()
    }

    static var allTests = [
        ("testContriesVarReturnsCorrectly", testContriesVarReturnsCorrectly)
    ]

    func testContriesVarReturnsCorrectly() {
        let result = sut.countries
        XCTAssertEqual(result, [country])
    }
}
