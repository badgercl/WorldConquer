import XCTest
import Foundation
@testable import WorldConquer

final class RandomClosenessTests: XCTestCase {
    var sut: RandomCloseness!
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
        sut = RandomCloseness()
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
        ("testNormalCase", testNormalCase),
        ("testInA1TerritoryWorldGetTheSame", testInA1TerritoryWorldGetTheSame)
    ]

    func testNormalCase() {
        let result = sut.getRandomCloseTerritory(for: territory1, in: world)
        XCTAssertEqual(result, territory2)
    }

    func testInA1TerritoryWorldGetTheSame() {
        let oneTerritoryWorld = World(age: 1, continents: [
            .init(name: "", territories: [territory1])
        ])
        let result = sut.getRandomCloseTerritory(for: territory1, in: oneTerritoryWorld)
        XCTAssertEqual(result, territory1)
    }
}
