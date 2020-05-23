import XCTest
import Foundation
@testable import WorldConquer

final class CountryTests: XCTestCase {
    var sut: Country!
    var territory: Territory!

    override func setUp() {
        super.setUp()
        sut = Country(name: "aName")
        territory = Territory(name: "someTerritory", population: 1, belongsTo: sut)

    }

    override func tearDown() {
        sut = nil
        territory = nil
        super.tearDown()
    }

    static var allTests = [
        ("testAdd", testAdd),
        ("testRemove", testRemove),
        ("testConquerAnotherTerritoryWorks", testConquerAnotherTerritoryWorks),
        ("testConquerAlreadyOwnedTerritoryDoesNothing", testConquerAlreadyOwnedTerritoryDoesNothing)
    ]

    func testAdd() {
        sut.add(territory: territory)
        XCTAssert(sut.territories.contains(territory))
    }

    func testRemove() {
        sut.add(territory: territory)
        sut.remove(territory: territory)
        XCTAssert(!sut.territories.contains(territory))
    }

    func testConquerAnotherTerritoryWorks() {
        let anotherCountry = Country(name: "anotherCountry")
        let anotherTerritory = Territory(name: "anotherTerritory", population: 2, belongsTo: anotherCountry)

        sut.conquer(territory: anotherTerritory)

        XCTAssertEqual(anotherCountry.territories.count, 0)
        XCTAssertEqual(sut.territories.count, 2)
        XCTAssertEqual(sut.territories, [territory, anotherTerritory])
    }

    func testConquerAlreadyOwnedTerritoryDoesNothing() {
        sut.conquer(territory: territory)

        XCTAssertEqual(sut.territories.count, 1)
        XCTAssertEqual(sut.territories, [territory])
    }
}
