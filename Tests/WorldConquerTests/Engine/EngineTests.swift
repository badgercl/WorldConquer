import Foundation
import XCTest
@testable import WorldConquer

final class EngineTests: XCTestCase {
    var sut: Engine!
    var world: World!
    var closenessCalculator: ClosenessCalculatorMock!
    var winningTerritoryCalculator: WinningTerritoryCalculatorMock!

    var country1: Country!
    var country2: Country!
    var country3: Country!
    var country4: Country!

    var territory1: Territory!
    var territory2: Territory!
    var territory3: Territory!
    var territory4: Territory!

    var continent1: Continent!
    var continent2: Continent!

    override func setUp() {
        closenessCalculator = ClosenessCalculatorMock()
        winningTerritoryCalculator = WinningTerritoryCalculatorMock()

        country1 = Country(name: "country 1")
        country2 = Country(name: "country 2")
        country3 = Country(name: "country 3")
        country4 = Country(name: "country 4")
        territory1 = Territory(name: "T1", population: 1, belongsTo: country1)
        territory2 = Territory(name: "T2", population: 2, belongsTo: country2)
        territory3 = Territory(name: "T3", population: 3, belongsTo: country3)
        territory4 = Territory(name: "T4", population: 4, belongsTo: country4)
        continent1 = Continent(name: "C1", territories: [territory1, territory2])
        continent2 = Continent(name: "C2", territories: [territory3, territory4])
        world = World.stub(continents: [continent1, continent2])

        sut = Engine(world: world,
                     closenessCalculator: closenessCalculator,
                     winningTerritoryCalculator: winningTerritoryCalculator)
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        closenessCalculator = nil
        winningTerritoryCalculator = nil
        world = nil
        country1 = nil
        country2 = nil
        country3 = nil
        country4 = nil
        territory1 = nil
        territory2 = nil
        territory3 = nil
        territory4 = nil
        continent1 = nil
        continent2 = nil
        super.tearDown()
    }

    static var allTests = [
        ("testSingleStep", testSingleStep),
        ("testSetpsUntilWinnerReportsWinner", testSetpsUntilWinnerReportsWinner),
        ("testInvalidStateThrows", testInvalidStateThrows),
    ]

    func testSingleStep() {
        // Given
        let conqueredTerritory = territory1
        let winningTerritory = territory3
        winningTerritoryCalculator.winningTerritoryReturnValue = winningTerritory
        closenessCalculator.getCloseTerritoryReturnValue = conqueredTerritory

        // When
        try! sut.step()
        let winner = sut.winner
        
        // Then
        XCTAssertNil(winner)
        XCTAssertEqual(territory1.belongsTo, territory3.belongsTo)
        XCTAssertEqual(country1.territories.count, 0)
        XCTAssertEqual(country3.territories.count, 2)
        XCTAssertEqual(country3.territories, [territory1, territory3])
    }

    func testSetpsUntilWinnerReportsWinner() {
        // Given
        winningTerritoryCalculator.winningTerritoryReturnValue = territory3

        // C2 conquers T1
        closenessCalculator.getCloseTerritoryReturnValue = territory1
        try! sut.step()

        // C2 conquers T2
        closenessCalculator.getCloseTerritoryReturnValue = territory2
        try! sut.step()

        // C2 conquers T4
        closenessCalculator.getCloseTerritoryReturnValue = territory4

        // When
        try! sut.step()
        let winner = sut.winner
        print(sut.currentWorld.description)

        // Then
        XCTAssertEqual(winner, country3)
        XCTAssertEqual(country3.territories, [territory1, territory2, territory3, territory4])
    }

    func testInvalidStateThrows() {
        let sut = Engine(world: World(age: LinearAge(age: 0), continents: []),
                         closenessCalculator: closenessCalculator,
                         winningTerritoryCalculator: winningTerritoryCalculator)
        XCTAssertThrowsError(try sut.step())
    }
}
