import XCTest
import Foundation
@testable import WorldConquer

final class RandomWinningTerritoryCalculatorTests: XCTestCase {
    var sut: RandomWinningTerritoryCalculator!
    var country1: Country!
    var country2: Country!
    var territory1: Territory!
    var territory2: Territory!
    var continent: Continent!
    var world: World!

    override func setUp() {
        super.setUp()
        country1 = Country(name: "country 1")
        country2 = Country(name: "country 2")
        territory1 = Territory(name: "T1", population: 1, belongsTo: country1)
        territory2 = Territory(name: "T2", population: 2, belongsTo: country2)
        continent = Continent(name: "continent", territories: [territory1, territory2])
        world = World(age: 1, continents: [continent])
        sut = RandomWinningTerritoryCalculator()
    }

    override func tearDown() {
        sut = nil
        country1 = nil
        country2 = nil
        territory1 = nil
        territory2 = nil
        continent = nil
        world = nil
        super.tearDown()
    }

    static var allTests = [
        ("testNormalWorldReturnTerritory", testNormalWorldReturnTerritory),
        ("testEmptyWorldReturnsNil", testEmptyWorldReturnsNil)
    ]

    func testNormalWorldReturnTerritory() {
        let result = sut.winningTerritory(in: world)
        XCTAssertNotNil(result)
    }

    func testEmptyWorldReturnsNil() {
        let result = sut.winningTerritory(in: World(age: 0, continents: []))
        XCTAssertNil(result)
    }
}
