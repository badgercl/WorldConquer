import XCTest
import Foundation
@testable import WorldConquer

final class WorldTests: XCTestCase {
    var sut: World!
    var continent1: Continent!
    var continent2: Continent!
    var territory1: Territory!
    var territory2: Territory!
    var country1: Country!
    var country2: Country!

    override func setUp() {
        super.setUp()
        country1 = Country(name: "country1")
        country2 = Country(name: "country2")
        territory1 = Territory(name: "territory1", population: 1, belongsTo: country1)
        territory2 = Territory(name: "territory2", population: 1, belongsTo: country2)
        continent1 = Continent(name: "continen1", territories: [territory1])
        continent2 = Continent(name: "continent2", territories: [territory2])
        sut = World(age: LinearAge(age: 1), continents: [continent1, continent2])
    }

    override func tearDown() {
        sut = nil
        country1 = nil
        country2 = nil
        territory1 = nil
        territory2 = nil
        continent1 = nil
        continent2 = nil
        super.tearDown()
    }

    static var allTests = [
        ("testInitialState", testInitialState),
        ("testNextIterationDifferentCountryChangesOwnership", testNextIterationDifferentCountryChangesOwnership),
        ("testNextIterationSameCountryDoesNothing", testNextIterationSameCountryDoesNothing),
        ("testWinnerIsntFound", testWinnerIsntFound),
        ("testWinnerFound", testWinnerFound)
    ]

    func testInitialState() {
        XCTAssertEqual(sut.countries, [country1, country2])
    }

    func testNextIterationDifferentCountryChangesOwnership() {
        sut.nextIteration(winningCountry: country2, conqueredTerritory: territory1)
        XCTAssertEqual(sut.age.description, "2")
        XCTAssertEqual(country2.territories, [territory2, territory1])
        XCTAssertEqual(country1.territories, [])
        XCTAssertEqual(territory1.belongsTo, country2)
    }

    func testNextIterationSameCountryDoesNothing() {
        sut.nextIteration(winningCountry: country2, conqueredTerritory: territory2)
        XCTAssertEqual(sut.age.description, "2")
        XCTAssertEqual(country1.territories, [territory1])
        XCTAssertEqual(country2.territories, [territory2])
        XCTAssertEqual(territory1.belongsTo, country1)
        XCTAssertEqual(territory2.belongsTo, country2)
    }

    func testWinnerIsntFound() {
        let result = sut.winner
        XCTAssertNil(result)
    }

    func testWinnerFound() {
        sut.nextIteration(winningCountry: country2, conqueredTerritory: territory1)
        let result = sut.winner
        XCTAssertEqual(result, country2)
    }
}
