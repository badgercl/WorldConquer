import XCTest
import Foundation
@testable import WorldConquer

final class ContinentBoundedClosenessCalculatorTests: XCTestCase {
    var randomizer: RandomizerMock!
    var sut: ContinentBoundedClosenessCalculator!
    var country1: Country!
    var country2: Country!
    var country3: Country!
    var territory1: Territory!
    var territory2: Territory!
    var territory3: Territory!
    var continent: Continent!
    var world: World!

    override func setUp() {
        super.setUp()
        randomizer = RandomizerMock()
        country1 = Country(name: "country 1")
        country2 = Country(name: "country 2")
        country3 = Country(name: "country 3")
        territory1 = Territory(name: "T1", population: 1, belongsTo: country1)
        territory2 = Territory(name: "T2", population: 2, belongsTo: country2)
        territory3 = Territory(name: "T3", population: 3, belongsTo: country3)
        continent = Continent(name: "continent", territories: [territory1, territory2])
        world = World(age: LinearAge(age: 0), continents: [continent])
        sut = makeSut()
    }

    override func tearDown() {
        sut = nil
        country1 = nil
        country2 = nil
        country3 = nil
        territory1 = nil
        territory2 = nil
        territory3 = nil
        continent = nil
        world = nil
        super.tearDown()
    }

    func makeSut(correctionFactor: Double = 0) -> ContinentBoundedClosenessCalculator {
        ContinentBoundedClosenessCalculator(randomizer: randomizer, correctionFactor: correctionFactor)
    }

    static var allTests = [
        ("testPickOwnContinentTerritoryScenario", testPickOwnContinentTerritoryScenario),
        ("testPickOtherContinentTerritoryByChanceScenario", testPickOtherContinentTerritoryByChanceScenario),
        ("testPickOtherContinentTerritoryWhenOwnContinentConqueredScenario", testPickOtherContinentTerritoryWhenOwnContinentConqueredScenario)
    ]

    func testPickOwnContinentTerritoryScenario() {
        randomizer.doubleReturnValue = 1.0
        randomizer.pickRandomReturnValue = territory2
        let continent1 = Continent(name: "C1", territories: [territory1, territory2])
        let continent2 = Continent(name: "C2", territories: [territory3])
        world = World(age: LinearAge(age: 0), continents: [continent1, continent2])
        let sut = makeSut(correctionFactor: 0.0)

        let result = sut.getCloseTerritory(for: territory1, in: world)

        XCTAssertEqual(result, territory2)
        XCTAssertEqual(randomizer.doubleCallCount, 1)
        XCTAssertEqual(randomizer.pickRandomCallCount, 1)
    }

    func testPickOtherContinentTerritoryByChanceScenario() {
        randomizer.doubleReturnValue = 1.0
        randomizer.pickRandomReturnValue = territory3
        let continent1 = Continent(name: "C1", territories: [territory1, territory2])
        let continent2 = Continent(name: "C2", territories: [territory3])
        world = World(age: LinearAge(age: 0), continents: [continent1, continent2])
        let sut = makeSut(correctionFactor: 1.0)

        let result = sut.getCloseTerritory(for: territory1, in: world)

        XCTAssertEqual(result, territory3)
        XCTAssertEqual(randomizer.doubleCallCount, 1)
        XCTAssertEqual(randomizer.pickRandomCallCount, 1)
    }

    func testPickOtherContinentTerritoryWhenOwnContinentConqueredScenario() {
        randomizer.doubleReturnValue = 1.0
        randomizer.pickRandomReturnValue = territory3
        let continent1 = Continent(name: "C1", territories: [territory1, territory2])
        let continent2 = Continent(name: "C2", territories: [territory3])
        world = World(age: LinearAge(age: 0), continents: [continent1, continent2])
        let sut = makeSut(correctionFactor: 1.0)

        country1.conquer(territory: territory2)
        let result = sut.getCloseTerritory(for: territory1, in: world)

        XCTAssertEqual(result, territory3)
        XCTAssertEqual(randomizer.doubleCallCount, 0)
        XCTAssertEqual(randomizer.pickRandomCallCount, 1)
    }
}

final class RandomizerMock: Randomizer {
    var doubleCallCount = 0
    var doubleReturnValue: Double!
    func double(in range: ClosedRange<Double>) -> Double {
        doubleCallCount += 1
        return doubleReturnValue
    }

    var pickRandomCallCount = 0
    var pickRandomReturnValue: Any!
    func pickRandom<T>(from collection: T) -> T.Element? where T : Collection {
        pickRandomCallCount += 1
        return pickRandomReturnValue as? T.Element
    }
}
